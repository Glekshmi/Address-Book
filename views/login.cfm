<cfoutput>
    <cfset myComponent = createObject("component", "controllers/addressBook").login()>

<!---<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <title>User Registration</title>
        <link href="./assets/css/styles.css" rel="stylesheet">
        <link href="./assets/css/icon.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
        <script src="./assets/js/jquery.js"></script>
        <script src="./assets/js/validation.js"></script>
    </head>
    <body class="bodySection">--->
       <!--<nav class="navbar navbar-expand-lg navbarStyle">
            <div class="container-fluid">
            <div class="navLogoTitle">
                <img src="./assets/images/contact-book.png" alt="" width="40" height="40" class="d-inline-block align-text-top">
                <a class="navbar-brand" href=""><h3 class="logoTitle">ADDRESS BOOK</h3></a>
            </div>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="navbarText" aria-controls="navbarText" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarText">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0"></ul>
                <div class="d-flex gap-4">
                    <div class="d-flex">
                        <span class="material-symbols-outlined navbarLogIcon">person</span>
                        <a class="navLinks ">SignUp</a>
                    </div>
                    <div class="d-flex">
                        <span class="material-symbols-outlined navbarLogIcon">login</span>
                        <a class="navLinks ">Login</a>
                    </div>
                </div>
                    
            </div>
            </div>
        </nav>-->
        <div class="container ">
            <div class="row loginContainer">
                <div class="col-2 loginSectionImg">
                   <img src="./assets/images/contact-book.png" alt=""  width="100" height="100" class="d-inline-block align-text-top">
                </div>
                <div class="col-4 loginSectionContent">
                    <p class="loginTitle">LOGIN</p>
                    <p id="validationMsg"></p><br>
                <form action="?action=login" method="post">
                  <div class="input-field">
                    <input type="text" name="strEmail" id="email" placeholder="email">  
                  </div>
                  <div class="input-field inputFieldBottom">
                    <input type="password" name="strPassword" id="password" placeholder="password">
                  </div>
                 <p id="validationMsg"></p><br>
                  <div class="loginBtnSection">
                  <button type="submit" class="btn btn-outline-primary btnSubmit" id="loginSubmit">LOGIN</button>
                    </div>
                </form> 
                <div class="loginBtnSection ">
                    
                    <p class="footerSignInSection">Or Sign In Using</p>
                </div>
                <div>
                    <div class="footerMediaIcons">
                        <img src="./assets/images/pngtree-facebook-logo-icon-design-vector-free-logo-design-template-png-image_3652951.png" alt="" width="65" height="62"  class="d-inline-block align-text-top mediaIcons">
                        <img src="./assets/images/google-symbol-logo-white-design-illustration-with-red-background-free-vector.jpg" alt="" width="42" height="39"  class="d-inline-block align-text-top mediaIcons" id="googleSignIn">
                        </div>
                        
                    </div>
                </div>
                <div class="loginBtnSection">
                    <p>Don't have an account?<a href="?action=signup">Register here.</a></p>
                </div>
                </div>
            </div>
        </div>

        <!---<div class="d-flex loginContainer">
            <div class="loginLeftSection">
                <p>hello</p>
            </div>
            <div class="loginRightSection">
                <p>login</p>
            </div>
        </div>--->

    </body>
</html>
</cfoutput>

