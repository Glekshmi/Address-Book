$(document).ready(function () {
	
	$('.hobbieDropdown .select-box').click(function() {
        $(this).toggleClass('active');
        $('#optionsList').toggle();
    });

    $('#optionsList').on('click', 'option', function(event) {
        event.preventDefault();
        $(this).toggleClass('selected');
        this.selected = $(this).hasClass('selected');
        updateHobbiesList();
    });


	$(document).ready(function () {
		let params = {};
		params={"http://mysite.local/":"display"};
		let regex = /([^&=]+)=([^&]*)/g,m;
		while ((m = regex.exec(location.href)) !== null) {
			params[decodeURIComponent(m[1])] = decodeURIComponent(m[2]);
		}
		if (Object.keys(params).length > 0) {
			localStorage.setItem('authInfo', JSON.stringify(params));
			window.history.pushState({}, document.title, "");
		}
		let info = JSON.parse(localStorage.getItem('authInfo'));
		if (info) {
			$.ajax({
				url: "https://www.googleapis.com/oauth2/v3/userinfo",
				headers: {
					"Authorization": `Bearer ${info['access_token']}`
				},
				success: function (response) {
					var formData = new FormData();
					formData.append('strEmail', response.email);
					formData.append('strFullName', response.name);
					formData.append('strUsername', response.given_name);
					formData.append('strPassword', 'NULL');
					formData.append('strPhoto', response.picture);
					formData.append('emailExist', response.email_verified);
					formData.append('intSubId', response.sub);
					$.ajax({
						url: "./controllers/addressBook.cfc?method=ssoLogin",
						type: 'post',
						data: formData,
						contentType: false,
						processData: false,
						dataType: 'json',
						success: function (response) {
							if (response.success && response.message != '') {
								ssoSaveUser(formData);
							} else if (response.success)
								window.location = "/display";
						},
						error: function (xhr, status, error) {
							console.log("An error occurred while checking:" + error);
						}
					});
					return false;
				},
				error: function (xhr, status, error) {
					console.log("An error occurred:" + error);
				}
			});
		}
	});

	function ssoSaveUser(formData) {
		$.ajax({
			url: './models/addressBook.cfc?method=registerUser',
			type: 'post',
			data: formData,
			contentType: false,
			processData: false,
			dataType: 'json',
			success: function (response) {
				if (response.success) {
					ssoLogin(formData);
				}
			}
		});
	}

	function ssoLogin(formData) {
		$.ajax({
			url: './controllers/addressBook.cfc?method=doLogin',
			type: 'post',
			data: formData,
			contentType: false,
			processData: false,
			dataType: 'json',
			success: function (response) {
				if (response.success) {
					window.location ="/display";
				} else
					console.log('an unexpected error has occurred');
			}
		});
	}

	$('#loginSubmit').click(function () {
		var strEmail = $('#email').val().trim();
		var strPassword = $('#password').val().trim();
		var intSubId = 0;
		if (strEmail === '' || strPassword === '') {
			$('#validationMsg').html('fill all the required fields!').css("color", "red");
			return false;
		}
		$.ajax({
			url: "./controllers/addressBook.cfc?method=doLogin",
			type: 'post',
			data: {
				strEmail: strEmail,
				strPassword: strPassword,
				intSubId:intSubId
			},
			dataType: 'JSON',
			success: function (response) {
				if (response.success == true) {
					$("#validationMsg").html(response.message).css("color", "green");
					window.location.href = "/display";
				} else {
					$("#validationMsg").html(response.message).css("color", "red");
				}
			},
			error: function (xhr, status, error) {
				console.log("An error occurred:" + error);
			}
		});
		return false;
	});

	$('#registerBtn').click(function () {
		var strFullName = $('#fullName').val().trim();
		var strEmail = $('#email').val().trim();
		var strUsername = $('#username').val().trim();
		var strPassword = $('#password').val().trim();
		var strPhoto = $('#photo')[0].files[0];
		var formData = new FormData();
		formData.append('strFullName', strFullName);
		formData.append('strEmail', strEmail);
		formData.append('strUsername', strUsername);
		formData.append('strPassword', strPassword);
		formData.append('strPhoto', strPhoto);
		formData.append('intSubId', '0');
		if (signUpValidate()) {
			$.ajax({
				url: "./controllers/addressBook.cfc?method=registerUser",
				type: 'post',
				data: formData,
				contentType: false,
				processData: false,
				dataType: 'JSON',
				success: function (response) {
					if (response.success == true) {
						setTimeout(function(){
							$("#registerError").html(response.message).css("color", "green");
							window.location.href = "/login";
						},1000
						);
					} else {
						$("#registerError").html(response.message).css("color", "red");
					}
				},
				error: function (xhr, status, error) {
					console.log("An error occurred:" + error);
				}
			});
			return false;
		}
		return false;
	});

	$("#createContactBtn").click(function () {
		$("#submitForm")[0].reset();
		$('#setTitle').html("CREATE CONTACT");
	});

	$("#uploadContactBtn").click(function () {
		$("#submitExcel")[0].reset();
	});

	$('.btnView').click(function () {
		var contactId = $(this).data('id');
		$.ajax({
			type: 'POST',
			url: './models/addressBook.cfc?method=getContact',
			data: {
				contactId: contactId
			},
				success: function (response) {
					if(response){
						var data = JSON.parse(response);
						var rowData = data.DATA[0];
						var name = `${rowData[0]} ${rowData[1]} ${rowData[2]}`;
						var address = `${rowData[6]} ${rowData[7]}`; 
						var dateString = rowData[4];
						var date = new Date(dateString);
						var formattedDate = date.getDate() + '-' + ('0' + (date.getMonth() + 1)).slice(-2) + '-' + ('0' + date.getFullYear()).slice(-4);

						$('#name').html(name);
						$('#gender').html(rowData[3]);
						$('#dob').html(formattedDate);
						$('#address').html(address);
						$('#pincode').html(rowData[8]);
						$('#email').html(rowData[9]);
						$('#phone').html(rowData[10]);
						$('#hobby').html(rowData[11]);
						$('#photo').attr('src', './assets/uploads/' + rowData[5]);
					}
			},
			error: function (xhr, status, error) {
				console.error(xhr.responseText);
			}
		});
	});

	$('.btnEdit').click(function () {
		var contactId = $(this).data('id');
		$('#setTitle').html("EDIT CONTACT");
			$.ajax({
				type: 'POST',
				url: './models/addressBook.cfc',
				data: {
					method : 'getContact',
					contactId: contactId
				},
				success: function (response) {
					if(response){
					var data = JSON.parse(response);
					var rowData = data.DATA[0];
					var dateString = rowData[4];
					var date = new Date(dateString);
					var formattedDate = date.getFullYear() + '-' + ('0' + (date.getMonth() + 1)).slice(-2) + '-' + ('0' + date.getDate()).slice(-2);
					$('#strTitle').val(rowData[0]);
					$('#strFirstName').val(rowData[1]);
					$('#strLastName').val(rowData[2]);
					$('#strGender').val(rowData[3]);
					$('#strDOB').val(formattedDate);
					$('#filePhoto').attr('src', './assets/uploads/' + rowData[5]);
					$('#strAddress').val(rowData[6]);
					$('#strStreet').val(rowData[7]);
					$('#strPincode').val(rowData[8]);
					$('#strEmail').val(rowData[9]);
					$('#strPhone').val(rowData[10]);
					$('#fileName').html(rowData[5]);
					$('#hiddenId').prop('value', contactId);

					var hobbyIds = rowData[12].split(',');
					$('#optionsList option.selected').removeClass('selected');
					for (var i = 0; i < hobbyIds.length; i++) {
						var id = hobbyIds[i].trim(); 
						var option = $('#optionsList option[value="' + id + '"]');
						if (option.length) {
							option.addClass('selected');
							option[0].selected = true;
						}
					}
					updateHobbiesList();
					
					}
				},
				error: function (xhr, status, error) {
					console.log("An error occurred:" + error);
				}
			});	
	});

	$('#submitForm').on('submit', function () {
		var contactId = $('#hiddenId').val().trim();
		var strEmail = $('#strEmail').val().trim();
		//var newHobbies = $('#optionsList').val();
		var selectedHobbies = [];
        $('#optionsList option.selected').each(function() {
            selectedHobbies.push($(this).val());
        });
        var selectedHobbies = selectedHobbies.join(', ');
		
		if(contactValidate()) {
			$.ajax({
				url: "./controllers/addressBook.cfc?method=checkEmailExist",
				type: 'post',
				data: {
					contactId: contactId,
					strEmail: strEmail,
				},
				dataType: 'JSON',
				success: function (response) {
					if (response.success) {
						saveContact(selectedHobbies);
					} else {
						$("#contactValidationMsg").html(response.message).css("color","red");
					}
				},
				error: function (xhr, status, error) {
					console.log("An error occurred:" + error);
				}
			}); return false;
		}
		return false;
	});

	$('#submitExcel').on('submit', function () {
		var fileExcel = $('#fileExcel')[0].files[0];
		var formData = new FormData();
		formData.append('fileExcel', fileExcel);
		$.ajax({
			url: "./controllers/addressBook.cfc?method=uploadExcelFile",
			type: 'post',
			data: formData,
			contentType: false,
			processData: false,
			dataType: 'JSON',
			success: function (response) {
				if (response.success) {
					setTimeout(function(){
						$("#excelValidationMsg").html(response.message).css("color", "green");
						window.location.href = "/display";
					},1000
					);
				 } else {
				 	$("#excelValidationMsg").html(response.message).css("color", "red");
				 }
			},
			error: function (xhr, status, error) {
				console.log("An error occurred:" + error);
			}
		});
		return false;
	});

	$('.confirmDeleteBtn').click(function () {
		deleteId = $(this).data('id');
		$.ajax({
			type: 'POST',
			url: './models/addressBook.cfc?method=deleteContact',
			data: {
				contactId: deleteId
			},
			success: function (response) {
				if (response.success == "true") {
					setTimeout(function(){
						window.location.href = "/display";
					},1000
					);
				}
			},
			error: function (xhr, status, error) {
				console.log("An error occurred:" + error);
			}
		});
	});

	$('#googleSignIn').on("click", function () {
		signIn();
	});

	$('#imagePath').change(function () {
		updateFileName(this);
	});

	$('#print').on('click', function () {
        var printArea = $('#printContent').html();
        $('body').html(printArea);
        window.print();
        window.location.href = "/display";
    });

});

function setHobbiesList(data) {
	var optionsList = $('#optionsList');
	optionsList.empty();
	var hobbies = data.DATA;
	hobbies.forEach(function([hobbyId, hobbyName]) {
		optionsList.append('<option value="' + hobbyId + '">' + hobbyName + '</option>');
	});
	}
$.ajax({
	url: './models/addressBook.cfc?method=getHobbies',
	method: 'GET',
	dataType: 'json',
	success: function(response) {
		if(response){
			setHobbiesList(response);
		}
	},
	error: function() {
		console.error('Failed to fetch hobbies.');
	}
});

function updateHobbiesList() {
	
	var hobbies = [];
	$('#optionsList option.selected').each(function() {
		hobbies.push($(this).text());
		
	});
	if (hobbies.length > 0) {
		$('.select-box').text(hobbies.join(', '));
	} else {
		$('.select-box').text('Select Options');
	}
}


function updateFileName(input) {
	var fileNamePlaceholder = document.getElementById("fileName");
	if (input.files.length > 0) {
		fileNamePlaceholder.textContent = input.files[0].name;
	} else {
		fileNamePlaceholder.textContent = 'No file chosen';
	}
}

function signIn() {
	let oauth2Endpoint = "https://accounts.google.com/o/oauth2/v2/auth";
	let $form = $('<form>')
		.attr('method', 'GET')
		.attr('action', oauth2Endpoint);
	let params = {
		"client_id": "662790131837-emjjrjcck71ier01p7c22cidel397q82.apps.googleusercontent.com",
		"redirect_uri": "https://redirectmeto.com/http://mysite.local/display",
		"response_type": "token",
		"scope": "https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email",
		"include_granted_scopes": "true",
		"state": 'pass-through-value'
	}; 
	$.each(params, function (name, value) {
		$('<input>')
			.attr('type', 'hidden')
			.attr('name', name)
			.attr('value', value)
			.appendTo($form);
	});
	$form.appendTo('body').submit();
}

function saveContact(selectedHobbies) {
	var contactId = $('#hiddenId').val().trim();
	var strTitle = $('#strTitle').val().trim();
	var strFirstName = $('#strFirstName').val().trim();
	var strLastName = $('#strLastName').val().trim();
	var strGender = $('#strGender').val().trim();
	var strDOB = $('#strDOB').val().trim();
	var strAddress = $('#strAddress').val().trim();
	var strStreet = $('#strStreet').val().trim();
	var strPhone = $('#strPhone').val().trim();
	var strEmail = $('#strEmail').val().trim();
	var strPincode = $('#strPincode').val().trim();
	var intHobbyId = selectedHobbies;
	
	var imageFile = $('#imagePath')[0].files[0];
	var formData = new FormData();
	formData.append('contactId', contactId);
	formData.append('strTitle', strTitle);
	formData.append('strFirstName', strFirstName);
	formData.append('strLastName', strLastName);
	formData.append('strGender', strGender);
	formData.append('strDOB', strDOB);
	formData.append('imageFile', imageFile);
	formData.append('strAddress', strAddress);
	formData.append('strStreet', strStreet);
	formData.append('strPincode', strPincode);
	formData.append('strEmail', strEmail);
	formData.append('strPhone', strPhone);
	formData.append('intHobbies', intHobbyId);
	$.ajax({
		url: './models/addressBook.cfc?method=saveContact',
		type: 'post',
		data: formData,
		contentType: false,
		processData: false,
		dataType: 'json',
		success: function (response) {
			if (response.success) {
				if (response.message == '') {
					$("#contactValidationMsg").html("Successfully completed registration").css("color", "green");
					window.location.href = "/display";
				} else {
					$("#contactValidationMsg").html(response.message).css("color", "green");
					window.location.href = "/display";
				} 
			} else {
				$("#contactValidationMsg").html("You can now update the contact").css("color", "red");
				return false;
			}
		},
	});
}

function signUpValidate() {
	var registerErrorMsg = '';
	var strFullName = $('#fullName').val().trim();
	var strEmail = $('#email').val().trim();
	var strUsername = $('#username').val().trim();
	var strPassword = $('#password').val().trim();
	var strConfirmpassword = $('#confirmpassword').val().trim();
	var emailRegex =/^[a-zA-Z0-9._%+-]+(?:\+1)?@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
	var passwordRegex = /^[a-zA-Z0-9!@#$%^&*]{8,16}$/;
	if (strFullName == '' || strEmail == '' || strUsername == '' || strPassword == '' || strConfirmpassword == '') {
		registerErrorMsg += 'All fields are required!' + "<br>";
	} else if (/\d/.test(strFullName)) {
		registerErrorMsg += 'FullName field should contain alphabets only!' + "<br>";
	} else if (strFullName.length > 15 || strFullName.length < 3) {
		registerErrorMsg += 'Exceeded the length of Full Name!';
	} else if (!strEmail.match(emailRegex)) {
		registerErrorMsg += 'Please enter a valid email id!' + "<br>";
	} else if (/\d/.test(strUsername)) {
		registerErrorMsg += 'Username field should contain alphabets only!' + "<br>";
	} else if (strUsername.length > 15 || strUsername.length < 3) {
		registerErrorMsg += 'Exceeded the length of Full Name!';
	} else if (strPassword.length < 8) {
		registerErrorMsg += 'Password should be at least 8 characters long!' + "<br>";
	} else if (!strPassword.match(passwordRegex)) {
		registerErrorMsg += 'Password should be a combination of alphabets, digits and special characters!' + "<br>";
	} else if (strConfirmpassword != strPassword) {
		registerErrorMsg += 'Password did not match!' + "<br>";
	}
	if (registerErrorMsg != '') {
		$("#registerError").html(registerErrorMsg).css("color", "red");
		return false;
	} 
		return true;
}

function contactValidate() {
	var contactErrorMsg = '';
	var strTitle = $('#strTitle').val().trim();
	var strFirstName = $('#strFirstName').val().trim();
	var strLastName = $('#strLastName').val().trim();
	var strGender = $('#strGender').val().trim();
	var strDOB = $('#strDOB').val().trim();
	var strAddress = DOMPurify.sanitize($('#strAddress').val().trim());
	var strStreet =  DOMPurify.sanitize($('#strStreet').val().trim());
	var strEmail = $('#strEmail').val().trim();
	var strPincode = $('#strPincode').val().trim();
	var strPhone = $('#strPhone').val().trim();
	var phoneRegex = /^(\+91[\-\s]?)?[0]?(91)?[789]\d{9}$/;
	var emailRegex =/^[a-zA-Z0-9._%+-]+(?:\+1)?@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;

	var currentYear = new Date().getFullYear();
	var enteredYear = parseInt(strDOB, 10);

	if (strTitle == '' || strFirstName == '' || strLastName == '' || strGender == '' || strDOB == '' || strAddress == '' || strStreet == '' || strEmail == '' || strPhone == '' || strPincode == '') {
		contactErrorMsg += 'All fields are required!';
	} else if (/\d/.test(strFirstName)) {
		contactErrorMsg += 'First Name field should contain alphabets only!';
	} else if (strFirstName.length > 15 || strFirstName.length < 3) {
		contactErrorMsg += 'Exceeded the length of First Name!';
	}else if (/\d/.test(strLastName)) {
		contactErrorMsg += 'Last Name field should contain alphabets only!';
	} else if (strLastName.length > 15) {
		contactErrorMsg += 'Exceeded the length of Last Name!';
	} else if (!strEmail.match(emailRegex)) {
		contactErrorMsg += 'Please enter a valid email id!';
	} else if (!isNaN(strAddress)) {
		contactErrorMsg += 'Address field should not contain digits only!';
	} else if (strAddress.length > 150) {
		contactErrorMsg += 'Exceeded the limit of address field!';
	}  else if (!isNaN(strStreet)) {
		contactErrorMsg += 'Street field should not contain digits only!';
	}  else if (strStreet.length > 50) {
		contactErrorMsg += 'Exceeded the limit of street field!';
	}  else if (isNaN(strPhone)) {
		contactErrorMsg += 'Phone field should contain digits only!';
	} else if (!phoneRegex.test(strPhone)){
		contactErrorMsg += 'Invalid phone number format. Phone number should either begin with "+91" or should have at least 10 digits!';
	} else if (enteredYear > currentYear) {
		contactErrorMsg += 'Entered year is invalid!';
	} else if (isNaN(strPincode)) {
		contactErrorMsg += 'Pincode field should contain digits only!';
	} else if (strPincode.length > 6) {
		contactErrorMsg += 'Exceeded the limit of pincode!';
	} 
	
	if (contactErrorMsg != '') {
		$("#contactValidationMsg").text(contactErrorMsg).css("color", "red");
		return false;
	} 
		return true;
}