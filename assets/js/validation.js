$(document).ready(function(){
    $('#loginSubmit').click(function(){
        var strUsername = $('#username').val().trim();
        var strPassword = $('#password').val().trim();
        if (strUsername === '' || strPassword === '') {
            $('#validationMsg').html('fill all the required fields!').css("color", "red");
           return false;
        }
        $.ajax({
            url:"./controllers/addressBook.cfc?method=doLogin",
            type:'post',
            data: {strUsername:strUsername,strPassword:strPassword},
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

    //signup
    // $('#registerBtn').click(function(){ 
    //     var strFullName = $('#fullName').val().trim();
    //     var strEmail = $('#email').val().trim();
    //     var strUsername = $('#username').val().trim();
    //     var strPassword = $('#password').val().trim();
        
    //     if(signUpValidate()){
    //         $.ajax({
    //             url:"./controllers/addressBook.cfc?method=registerUser",
    //             type:'post',
    //             data: {strFullName:strFullName,strEmail:strEmail,strUsername:strUsername,strPassword:strPassword},
    //             dataType:'JSON',
    //             success: function(response) {
                    
    //                 if (response.success == true) {
    //                     $("#registerError").html(response.message).css("color","green");
    //                     setTimeout(function(){
    //                         window.location.href="?action=display";
    //                     },1000
    //                 );
    
    //                 } else { 
    //                      $("#registerError").html(response.message).css("color","red");
    //                 }
                    
    //             },
    //             error: function(xhr, status, error) {
    //                 alert("An error occurred:"+error);
    //             }
                
    //         });
    //         return false;
    //     }
    //    return false;
        
    // });

    $('#registerBtn').click(function(){ 
        var strFullName = $('#fullName').val().trim();
        var strEmail = $('#email').val().trim();
        var strUsername = $('#username').val().trim();
        var strPassword = $('#password').val().trim();
        var strImageFile = $('#image').val().trim();
        alert(strImageFile);
        if(signUpValidate()){
            $.ajax({
                url:"./controllers/addressBook.cfc?method=registerUser",
                type:'post',
                data: {strFullName:strFullName,strEmail:strEmail,strUsername:strUsername,strPassword:strPassword},
                dataType:'JSON',
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
                   
                    $('#' + column.toLowerCase()).html(value);
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
        
        $.ajax({
            type: 'POST',
            url: './models/addressBook.cfc?method=getContact',
            data: {contactId: contactId},
            success: function(response) {
                var data = JSON.parse(response);
                alert(data.firstname);
                alert(data.lastname);
                var dateString = data.dob;
                var date = new Date(dateString);
                var formattedDate = date.getFullYear() + '-' + ('0' + (date.getMonth() + 1)).slice(-2) + '-' + ('0' + date.getDate()).slice(-2);
                
                $('#strTitle').val(data.title);
                $('#strFirstName').val(data.firstname);
                $('#strLastName').val(data.lastname);
                $('#strGender').val(data.gender);
                $('#strDOB').val(formattedDate);
                $('#strAddress').val(data.address);
                $('#strStreet').val(data.street);
                $('#strEmail').val(data.email);
                $('#strPhone').val(data.phone);
                $('#hiddenId').prop('value',contactId); 
            },
            error: function(xhr, status, error) {
              
            }
        });
    });

    $('#formSubmit').click(function(){ 
        var contactId = $('#hiddenId').val().trim();
        var strEmail = $('#strEmail').val().trim();
        alert(contactId);
            $.ajax({
                url:"./controllers/addressBook.cfc?method=checkEmailExist",
                type:'post',
                data: { contactId:contactId,
                    strEmail:strEmail,
                    },
                dataType:'JSON',
                success: function(response) {
                    alert(response.success);
                    if (response.success == false) {
                        $("#contactValidationMsg").html(response.message).css("color","red");
                        setTimeout(function(){
                            window.location.href="?action=display";
                        },1000
                    );
                    } 
                    else { 
                        $.ajax({
                            type: 'POST',
                            url: './controllers/addressBook.cfc?method=updateContact',
                            data: {contactId: contactId,
                                strTitle:strTitle,
                                strFirstName:strFirstName,
                                strLastName:strLastName,
                                strGender:strGender,
                                strDOB:strDOB,
                                strAddress:strAddress,
                                strStreet:strStreet,
                                strEmail:strEmail,
                                strPhone:strPhone
                            },
                            success: function(response) {
                                alert(response);
                            },
                            error: function(xhr, status, error) {
                              
                            }
                        });
                         
                    }
                },
                error: function(xhr, status, error) {
                    alert("An error occurred:"+error);
                }
                
            });
            return false;
    });
    
    // $('#formUpdateBtn').click(function() {
        
    //     var strTitle = $('#strTitle').val().trim();
    //     var strFirstName = $('#strFirstName').val().trim();
    //     var strLastName = $('#strLastName').val().trim();
    //     var strGender = $('#strGender').val().trim();
    //     var strDOB = $('#strDOB').val().trim();
    //     var strAddress = $('#strAddress').val().trim();
    //     var strStreet = $('#strStreet').val().trim();
    //     var strEmail = $('#strEmail').val().trim();
    //     var strPhone = $('#strPhone').val().trim();
        
    //     $.ajax({
    //         type: 'POST',
    //         url: './controllers/addressBook.cfc?method=checkContactExist',
    //         data: {
    //             contactId: contactId,
    //             strEmail:strEmail,
    //         },
    //         success: function(response) {
    //             if (response.success == false) {
    //                 $("#contactValidationMsg").html(response.message).css("color","red");
    //                 setTimeout(function(){
    //                     window.location.href="?action=display";
    //                     },1000
    //                 );

    //             } 
    //             else { 
    //                 $.ajax({
    //                     type: 'POST',
    //                     url: './controllers/addressBook.cfc?method=updateContact',
    //                     data: {
    //                         contactId: contactId,
    //                         strTitle:strTitle,
    //                         strFirstName:strFirstName,
    //                         strLastName:strLastName,
    //                         strGender:strGender,
    //                         strDOB:strDOB,
    //                         strAddress:strAddress,
    //                         strStreet:strStreet,
    //                         strEmail:strEmail,
    //                         strPhone:strPhone
    //                     },
    //                     success: function(response) {
    //                         if (response.success == true) {
    //                             $("#contactValidationMsg").html(response.message).css("color","green");
    //                             setTimeout(function(){
    //                                 window.location.href="?action=display";
    //                                 },1000
    //                             );
            
    //                         } else { 
                               
    //                             $("#contactValidationMsg").html(response.message).css("color","red");
    //                             setTimeout(function(){
    //                                 window.location.href="?action=display";
    //                                 },1000
    //                             );
    //                         }
            
    //                     },
    //                     error: function(xhr, status, error) {
                           
    //                     }
    //                 });
    //             }

    //         },
    //         error: function(xhr, status, error) {
               
    //         }
    //     });
    // });

    $('.btnDelete').click(function(){
        deleteId = $(this).data('id');
      });
      $('.confirmDeleteBtn').click(function(){
        $.ajax({
          type: 'POST',
          url: './models/addressBook.cfc?method=deleteContact',
          data: {contactId: deleteId},
          success: function(response) {
            if(response.success){
                setTimeout(function(){
                    window.location.href="?action=display";
                },1000
            );
                //$(deleteId).closest('tr').remove();
                window.location.href="?action=display";
            }
          },
          error: function(xhr, status, error) {
          }
        });
      });
});

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

/*function contactValidate(){ 
    
	var contactErrorMsg='';
    var emailRegex = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
	var strTitle = $('#strTitle').val().trim();
	var strFirstName = $('#strFirstName').val().trim();
    var strLastName = $('#strLastName').val().trim();
	var strGender = $('#strGender').val().trim();
    var strDOB = $('#strDOB').val().trim();
	var strAddress = $('#strAddress').val().trim();
    var strStreet = $('#strStreet').val().trim();
	var strEmail = $('#password').val().trim();
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
    
}*/