$(document).ready(function(){
    

    $(document).ready(function(){
        let params = {};
        let regex = /([^&=]+)=([^&]*)/g,m;

        while ((m = regex.exec(location.href)) !== null) {
            params[decodeURIComponent(m[1])] = decodeURIComponent(m[2]);
        }

        if (Object.keys(params).length > 0) {
            localStorage.setItem('authInfo', JSON.stringify(params));
            //window.history.pushState({}, document.title, "/Address-Book/?action=display");
        }

        let info = JSON.parse(localStorage.getItem('authInfo'));
    
        if (info) {
            $.ajax({
                url: "https://www.googleapis.com/oauth2/v3/userinfo",
                headers: {
                    "Authorization": `Bearer ${info['access_token']}`
                },
                success: function(response) {
                    var formData = new FormData();
                    formData.append('strEmail', response.email);
                    formData.append('strFullName', response.name);
                    formData.append('strUsername', response.given_name);
                    formData.append('strPassword','NULL');
                    formData.append('strPhoto',response.picture);
                    formData.append('emailExist', response.email_verified);
                    formData.append('intSubId', response.sub);
                    alert(response.sub);
                    $.ajax({
                        url:"./controllers/addressBook.cfc?method=ssoLogin",
                        type: 'post',
                        data: formData,
                        contentType: false, 
                        processData: false,
                        dataType: 'json',
                        success: function(response) {
                            alert(response.success+""+response.message);
                            if(response.success && response.message!=''){
                                ssoSaveUser(formData);
                            }
                            else if(response.success && response.msg=='')
                                window.location="?action=display";
                        },
                        error: function(xhr, status, error) {
                            alert("An error occurred while checking:"+error);
                        }
                        
                    });
                    return false;
                    
                },
                 error: function(xhr, status, error) {
                //     alert("An error occurred: " + error);
                }
            });
        }
    });
    
    function ssoSaveUser(formData){
        $.ajax({
            url: './models/addressBook.cfc?method=registerUser',
            type: 'post',
            data: formData,
            contentType: false, 
            processData: false, 
            dataType: 'json',
            success: function(response) {
                if(response.success ){
                    ssoLogin(formData);
                }
            }
        });
    }

    function ssoLogin(formData){
        $.ajax({
            url: './controllers/addressBook.cfc?method=dologin',
            type: 'post',
            data: formData,
            contentType: false, 
            processData: false, 
            dataType: 'json',
            success:function(response){
                if(response.success){
                    window.location="?action=display"; 
                }
                else
                    alert('an unexpected error has occurred');
            }
        });
    }

    $('#loginSubmit').click(function(){
        var strEmail = $('#email').val().trim();
        var strPassword = $('#password').val().trim();
        if (strEmail === '' || strPassword === '') {
            $('#validationMsg').html('fill all the required fields!').css("color", "red");
           return false;
        }
        $.ajax({
            url:"./controllers/addressBook.cfc?method=doLogin",
            type:'post',
            data: {strEmail:strEmail,strPassword:strPassword},
            dataType:'JSON',
            success: function(response) {
                if (response.success == true) {
                    $("#validationMsg").html(response.message).css("color","green");
                    setTimeout(function(){
                        window.location.href="?action=display";
                    },1000
                );
                } else { 
                     $("#validationMsg").html(response.message).css("color","red");
                }
            },
            error: function(xhr, status, error) {
                alert("An error occurred:"+error);
            }
            
        });
        return false;
    });

    $('#registerBtn').click(function(){ 
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
        
        if(signUpValidate()){
            $.ajax({
                url:"./controllers/addressBook.cfc?method=registerUser",
                type:'post',
                data: formData,
                contentType: false, 
                processData: false, 
                dataType: 'JSON',
                success: function(response) {
                    
                    if (response.success == true) {
                        $("#registerError").html(response.message).css("color","green");
                        setTimeout(function(){
                            window.location.href="?action=display";
                        },1000
                    );
    
                    } else { 
                         $("#registerError").html(response.message).css("color","red");
                    }
                    
                },
                error: function(xhr, status, error) {
                    alert("An error occurred:"+error);
                }
                
            });
            return false;
        }
       return false;
        
    });
    
    $("#createContactBtn").click(function() { 
        $("#submitForm")[0].reset();
        $('#setTitle').html("CREATE CONTACT");
    }); 

    //view
    $('.btnView').click(function(){
        var contactId = $(this).data('id');
        $.ajax({
            type: 'POST',
            url: './models/addressBook.cfc?method=getContactDetails',
            data: {contactId: contactId},
            success: function(response){
                
                var data = JSON.parse(response);
                var columns = data.COLUMNS;
                var rowData = data.DATA[0]; 
                
                for (var i = 0; i < columns.length; i++) {
                    
                    var column = columns[i];
                    var value = rowData[i];
                    if(column.toLowerCase() === 'photo'){
                        $('#photo').attr('src','./assets/uploads/'+value);
                    }
                    else if (column.toLowerCase() === 'dob') {
                        var dateString = value;
                        var date = new Date(dateString);
                        var formattedDate = date.getDate() + '-' + ('0' + (date.getMonth() + 1)).slice(-2) + '-' + ('0' + date.getFullYear()).slice(-4);
                        $('#' + column.toLowerCase()).html(formattedDate);
                    }

                    else{
                        $('#' + column.toLowerCase()).html(value);
                    }
                   
                }
                //window.reload();
            },
            error: function(xhr, status, error){
                console.error(xhr.responseText);
            }
        });
    });

    //edit
    $('.btnEdit').click(function() {
        var contactId = $(this).data('id');
        $('#setTitle').html("EDIT CONTACT");
        $.ajax({
            type: 'POST',
            url: './models/addressBook.cfc?method=getContact',
            data: {contactId: contactId},
            success: function(response) {
                var data = JSON.parse(response);
                var dateString = data.dob;
                var date = new Date(dateString);
                var formattedDate = date.getFullYear() + '-' + ('0' + (date.getMonth() + 1)).slice(-2) + '-' + ('0' + date.getDate()).slice(-2);
              
                $('#strTitle').val(data.title);
                $('#strFirstName').val(data.firstname);
                $('#strLastName').val(data.lastname);
                $('#strGender').val(data.gender);
                $('#strDOB').val(formattedDate);
                $('#fileName').text(data.photo);
                $('#strAddress').val(data.address);
                $('#strStreet').val(data.street);
                $('#strPincode').val(data.pincode);
                $('#strEmail').val(data.email);
                $('#strPhone').val(data.phone);
                $('#hiddenId').prop('value',contactId); 

                
            },
            error: function(xhr, status, error) {
              
            }
        });
    });

    $('#submitForm').on('submit',function(){ 
        var contactId = $('#hiddenId').val().trim();
        var strEmail = $('#strEmail').val().trim();
        
        if(contactValidate()){
          
            $.ajax({
                url:"./controllers/addressBook.cfc?method=checkEmailExist",
                type:'post',
                data: { contactId:contactId,
                    strEmail:strEmail,
                    },
                dataType:'JSON',
                success: function(response) {
                    alert(response.success);
                    if (response.success) {
                        saveContact();
                    } 
                    else { 
                        $("#contactValidationMsg").html(response.message).css("color","red");
                        setTimeout(function(){
                            window.location.href="?action=display";
                        },1000
                    );  
                    }
                },
                error: function(xhr, status, error) {
                    alert("An error occurred:"+error);
                }
                
            });
        }
        return false;
                    
    });

    $('#submitExcel').on('submit',function(){ 
        var fileExcel = $('#fileExcel')[0].files[0];
        var formData = new FormData();
        formData.append('fileExcel', fileExcel);
        $.ajax({
            url:"./controllers/addressBook.cfc?method=checkExcelFileExist",
            type:'post',
            data: formData,
            contentType: false, 
            processData: false, 
            dataType: 'JSON',
            success: function(response) {
                console.log(response);
                
            },
            error: function(xhr, status, error) {
                alert("An error occurred:"+error);
            }
            
        });
        return false;
    });
    
    $('.confirmDeleteBtn').click(function(){
        deleteId = $(this).data('id');
        var deleteElement = $(this).closest('tr');
        $.ajax({
          type: 'POST',
          url: './models/addressBook.cfc?method=deleteContact',
          data: {contactId: deleteId},
          success: function(response) {
            if(response.success){
                deleteElement.remove();             
            }
          },
          error: function(xhr, status, error) {
          }
        });
    });
    
    $('#imagePath').change(function() {
    updateFileName(this);
    });

    $('#googleSignIn').on("click",function(){
    signIn();
    });

}); 

function signIn() {
    let oauth2Endpoint = "https://accounts.google.com/o/oauth2/v2/auth";

    let $form = $('<form>')
        .attr('method', 'GET')
        .attr('action', oauth2Endpoint);

    let params = {
        "client_id": "662790131837-emjjrjcck71ier01p7c22cidel397q82.apps.googleusercontent.com",
        "redirect_uri": "http://127.0.0.1:8500/Address%20Book%20Task/Address-Book/?action=display",
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


function updateFileName(input) {
    var fileNamePlaceholder = document.getElementById("fileName");
    if (input.files.length > 0) {
        fileNamePlaceholder.textContent = input.files[0].name;
    } else {
        fileNamePlaceholder.textContent = 'No file chosen'; 
    }
}

function saveContact(){
   
    var contactId = $('#hiddenId').val().trim();
    var strTitle = $('#strTitle').val().trim();
    var strFirstName = $('#strFirstName').val().trim();
    var strLastName = $('#strLastName').val().trim();
    var strGender = $('#strGender').val().trim();
    var strDOB=$('#strDOB').val().trim();
    var strAddress=$('#strAddress').val().trim();
    var strStreet=$('#strStreet').val().trim();
    var strPhone=$('#strPhone').val().trim();
    var strEmail=$('#strEmail').val().trim();
    var strPincode=$('#strPincode').val().trim();
   
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
    
    $.ajax({
        url:'./models/addressBook.cfc?method=saveContact',
        type:'post',
        data: formData,
        contentType: false, 
        processData: false, 
        dataType: 'json',
        success: function(response) {
            
            if (response.success){
                if(response.message==''){
                    $("#contactValidationMsg").html("Successfully completed registration").css("color", "green");
                    window.location.href="?action=display";
                }
                else{
                    $("#contactValidationMsg").html(response.message).css("color","green");
                        window.location.href="?action=display";
                }
            } 
            else {
                $("#contactValidationMsg").html("You can now update the contact").css("color", "red");
                return false;
            }
        },
    });   
}
   

function signUpValidate(){
	var registerErrorMsg='';
    var emailRegex = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
    var passwordRegex = /^[a-zA-Z0-9!@#$%^&*]{6,16}$/;
	var strFullName = $('#fullName').val().trim();
	var strEmail = $('#email').val().trim();
    var strUsername = $('#username').val().trim();
	var strPassword = $('#password').val().trim();
    var strConfirmpassword = $('#confirmpassword').val().trim();
    if (strFullName == '' || strEmail == '' || strUsername == '' || strPassword == '' || strConfirmpassword == ''){
        registerErrorMsg+='All fields are required!'+"<br>";
    }
	else if (/\d/.test(strFullName)) {
		registerErrorMsg+='FullName field should contain alphabets only!'+"<br>";
       
	} 
    else if (!strEmail.match(emailRegex)){
		registerErrorMsg+='Please enter a valid email id!'+"<br>";
		
	}
    else if (/\d/.test(strUsername)) {
		registerErrorMsg+='Username field should contain alphabets only!'+"<br>";
	}
    else if(strPassword.length < 8){
        registerErrorMsg+='Password should be at least 8 characters long!'+"<br>";
    }
    else if (!strPassword.match(passwordRegex)){
		registerErrorMsg+='Password should be a combination of alphabets, digits and special characters!'+"<br>";
		
	}
    else if(strConfirmpassword != strPassword){
        registerErrorMsg+='Password did not match!'+"<br>";
    }
	
	if(registerErrorMsg != ''){
		$("#registerError").html(registerErrorMsg).css("color","red");
		return false;
	}
	else{
		return true;
	}
}

function contactValidate(){ 
    
	var contactErrorMsg='';
    var emailRegex = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
	var strTitle = $('#strTitle').val().trim();
	var strFirstName = $('#strFirstName').val().trim();
    var strLastName = $('#strLastName').val().trim();
	var strGender = $('#strGender').val().trim();
    var strDOB = $('#strDOB').val().trim();
	var strAddress = $('#strAddress').val().trim();
    var strStreet = $('#strStreet').val().trim();
	var strEmail = $('#strEmail').val().trim();
    var strPhone = $('#strPhone').val().trim();  
    if (strTitle == '' || strFirstName == '' || strLastName == '' || strGender == '' || strDOB == '' || strAddress == '' || strStreet == '' || strEmail == '' || strPhone == ''){
        contactErrorMsg+='All fields are required!'+"<br>";
    }
	else if (/\d/.test(strFirstName)) {
		contactErrorMsg+='First Name field should contain alphabets only!'+"<br>";
	} 
    else if (/\d/.test(strLastName)) {
		contactErrorMsg+='Last Name field should contain alphabets only!'+"<br>";
       
	} 
    else if (!strEmail.match(emailRegex)){
		contactErrorMsg+='Please enter a valid email id!'+"<br>";
		
	}
    else if (!isNaN(strAddress)) {
		contactErrorMsg+='Address field should not contain digits only!'+"<br>";
	}
    else if (!isNaN(strStreet)) {
		contactErrorMsg+='Street field should not contain digits only!'+"<br>";
	}
    else if (isNaN(strPhone)) {
		contactErrorMsg+='Phone field should contain digits only!'+"<br>";
	}
	
	if(contactErrorMsg != ''){
		$("#contactValidationMsg").html(contactErrorMsg).css("color","red");
       
		return false;
	}
	else{
		return true;
	}
    
}