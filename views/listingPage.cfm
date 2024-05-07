<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <title>User Registration</title>
        <link href="./assets/css/styles.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
        <script src="./assets/js/jquery.js"></script>
        <script src="./assets/js/validation.js"></script>
    </head>
    <body class="bodySection">
        <cfoutput>
       <nav class="navbar navbar-expand-lg navbarStyle">
            <div class="container-fluid">
            <div class="navLogoTitle">
                <img src="./assets/images/contact-book.png" alt="" width="40" height="40" class="d-inline-block align-text-top">
                <a class="navbar-brand" href=""><h3 class="logoTitle">ADDRESS BOOK</h3></a>
            </div>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="navbarText" aria-controls="navbarText" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarText">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                </ul>
                <span class="navbar-text logoutIcon">
                    <div class="NavbarLogoutLink">
                        <img src="./assets/images/icons8-exit-24.png" alt="" width="16" height="16" class=" logoutImg">
                        <a class="navLinks logoutLink">Logout</a>
                    </div>
                </span>
            </div>
            </div>
        </nav>
        
        

        <div class="listingPageSection">
            <div class="topDownloadBar">
                <img src="./assets/images/pdf.PNG" alt="" width="30" height="32" class="d-inline-block align-text-top logoutImg">
                <img src="./assets/images/excel.PNG" alt="" width="26" height="32" class="d-inline-block align-text-top logoutImg">
                <img src="./assets/images/printer.PNG" alt="" width="32" height="34" class="d-inline-block align-text-top logoutImg">
            </div>
            <div class="midSection">
                <div class="createContactSection">
                    <div>
                        <img src="./assets/images/Capture.PNG" alt="" width="30" height="32" class="d-inline-block align-text-top logoutImg">
                    </div>
                </div>
                <div class="dataListingSection">
                    <table border="0">
                        <tr>
                            <th>NAME</th>
                            <th>EMAIL ID</th>
                            <th>PHONE NUMBER</th>
                        </tr>
                    </table>
                </div>
            </div>
        </div>

    </body>
</cfoutput>
</html>

