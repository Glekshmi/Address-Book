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
    $('#registerBtn').click(function(){ 
        var strFullName = $('#fullName').val().trim();
        var strEmail = $('#email').val().trim();
        var strUsername = $('#username').val().trim();
        var strPassword = $('#password').val().trim();
        
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
		//alert(errorMsg);
	}
    else if (/\d/.test(strUsername)) {
		registerErrorMsg+='Username field should contain alphabets only!'+"<br>";
	}
    else if(strPassword.length < 8){
        registerErrorMsg+='Password should be at least 8 characters long!'+"<br>";
    }
    else if (!strPassword.match(passwordRegex)){
		registerErrorMsg+='Password should be a combination of alphabets, digits and special characters!'+"<br>";
		//alert(errorMsg);
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