<cfinclude  template="header.cfm">
<!---<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <title>User Registration</title>
        <link href="../assets/css/styles.css" rel="stylesheet">
        <link href="./assets/css/icon.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
        <script src="./assets/js/jquery.js"></script>
        <script src="./assets/js/validation.js"></script>
    </head>
    <body class="bodySection">--->
    <cfoutput>
       <nav class="navbar navbar-expand-lg navbarStyle">
            <div class="container-fluid">
            <div class="navLogoTitle">
                <img src="../assets/contact-book.png" alt="" width="40" height="40" class="d-inline-block align-text-top">
                <a class="navbar-brand" href=""><h3 class="logoTitle">ADDRESS BOOK</h3></a>
            </div>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="navbarText" aria-controls="navbarText" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarText">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                </ul>
                <span class="navbar-text">
                    <span class="material-symbols-outlined">person</span>
                    <a class="navLinks">SignUp</a>
                    <span class="material-symbols-outlined navbarLogIcon">login</span>
                    <a class="navLinks">Login</a>
                </span>
            </div>
            </div>
        </nav>
        <div class="container ">
            <div class="row ">
                <div class="col-2 loginSectionImg signInSection">
                   <img src="../assets/contact-book.png" alt=""  width="100" height="100" class="d-inline-block align-text-top">
                </div>
                <div class="col-4 loginSectionContent signInSection">
                    <p class="loginTitle">SIGN UP</p>
                    <p id="registerError"></p>
                <form action="?action=signup" method="post"> 
                  <div class="input-field">
                    <input type="text" name="strFullName" id="fullName" placeholder="Full Name">  
                  </div>
                  <div class="input-field inputFieldBottom">
                    <input type="text" name="strEmail" id="email" placeholder="Email ID">
                  </div>
                  <div class="input-field inputFieldBottom">
                    <input type="text" name="strUsername" id="username" placeholder="Username">
                  </div>  
                  <div class="input-field inputFieldBottom">
                    <input type="password" name="strPassword" id="password" placeholder="Password">
                  </div>
                  <div class="input-field inputFieldBottom">
                    <input type="password" name="strConfirmPassword" id="confirmpassword" placeholder="Confirm Password">
                  </div>
                  <div class="loginBtnSection">
                  <button type="submit" class="btn btn-outline-primary btnSubmit" id="registerBtn">Register</button>
                    </div>
                </form> 
                
                </div>
            </div>
        </div>
        </cfoutput>
    </body>
</html>


