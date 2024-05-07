$(document).ready(function(){
    $('#loginSubmit').click(function(){
        var strUsername = $('#username').val().trim();
        var strPassword = $('#password').val().trim();
       alert("hai");
        if (strUsername === '' || strPassword === '') {
            $('#validationMsg').html('fill all the required fields').css("color", "red");
           return false;
        }
        $.ajax({
            url:"../controllers/addressBook.cfc?method=doLogin",
            type:'post',
            data: {strUsername:strUsername,strPassword:strPassword},
            dataType:'JSON',
            success: function(response) {
                if (response.message == "exists") {
                    $("#validationMsg").html(response.message).css("color","green");
                    setTimeout(function(){
                        window.location.href="../views/main.cfm";
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
    
    

});