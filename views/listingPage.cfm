<cfinclude  template="header.cfm">
<!---<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <title>User Registration</title>
        <link href="./assets/css/styles.css" rel="stylesheet">
        <link href="./assets/css/icon.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
        <script src=" https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
        <script src="./assets/js/jquery.js"></script>
        <script src="./assets/js/validation.js"></script>

       
    </head>
    <body class="bodySection">--->
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
                        <div class="NavbarLogoutLink d-flex">       
                                <span class="material-symbols-outlined navbarLogIcon">logout</span>
                                <span><a class="navLinks logoutLink" href="?action=login">Logout</a></span>                 
                        </div>
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
                    <div class="loginUserImg">
                        <img src="./assets/images/Capture.PNG" alt=""  class="d-inline-block align-text-top">
                    </div>
                    <div class="loginUserName">
                        <p>Merlin Richard</p>
                    </div>
                    <div class="createBtnSection">
                        <button type="button" class="btn btn-primary createBtn m-0" data-bs-toggle="modal" data-bs-target="##myModal">CREATE CONTACT</button>
                        <div class="modal bd-example-modal-lg fade contactPopUp" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true" id="myModal">
                            <div class="modal-dialog modal-lg p-1">
                                <div class="modal-content ps-3 outerContainer">
                                    <!---begin--->
                                    <div class="d-flex justify-content-between ">
                                        <div class="popupContactHeader">
                                            <div  class="d-flex justify-content-center subHeader">
                                                <p class="contactMainTitle">CREATE CONTACT</p>
                                            </div>
                                            <div class="d-flex personalContact commonStyle">
                                                <p class="">Personal Contact</p>
                                            </div>
                                            <div class="commonStyle contactFormSection">
                                                <form action="" method="post"  enctype="multipart/form-data">
                                                    <div class="firstNameSection d-flex">
                                                        <div class="d-flex flex-column ">
                                                            <label for="strTitle">Title*</label>
                                                            <select name ="strTitle" class="selectTitle commonInputStyle">
                                                                <option></option>
                                                                <option value="Miss">Miss</option>
                                                                <option value="Mister">Mister</option>
                                                            </select>
                                                        </div>
                                                        <div class="d-flex flex-column">
                                                            <label for="strFirstName">First Name*</label>
                                                            <input type="text" id="strFirstName" class="commonNameStyle setNameWidth" name="strFirstName" placeholder="Your First Name" >
                                                        </div>
                                                        <div class="d-flex flex-column">
                                                            <label for="strLastName">Last Name*</label>
                                                            <input type="text" id="strLastName" class="commonNameStyle setNameWidth" name="strLastName" placeholder="Your Last Name" >
                                                        </div>
                                                    </div>
                                                    <div class="lastNameSection d-flex">
                                                        <div class="d-flex flex-column ">
                                                            <label for="strGender">Gender*</label>
                                                            <select name ="strGender" class="selectTitle commonNameStyle setGenderWidth">
                                                                <option></option>
                                                                <option value="Male">Male</option>
                                                                <option value="Female">Female</option>
                                                                <option value="Other">Other</option>                    
                                                            </select>
                                                        </div>
                                                        <div class="d-flex flex-column">
                                                            <label for="strDOB">Date Of Birth*</label>
                                                            <input type="date" id="strDOB" class="commonNameStyle setDateWidth" name="strDOB" placeholder="Your First Name" >
                                                        </div>
                                                    </div>
                                                    <div class="lastNameSection d-flex flex-column">
                                                        <!---<div class="d-flex">
                                                            <p class="">Contact Details</p>
                                                        </div>--->
                                                        <div class="d-flex flex-column">
                                                            <div class="photoStyle">
                                                                <p class="mb-1">Upload Photo</p>
                                                            </div>
                                                            <input type="file" id="strPhoto" class="commonNameStyle setFileWidth pt-1 pb-1" name="strPhoto" placeholder="Your First Name" >
                                                        </div>
                                                    </div>
                                                    <div class="d-flex mt-4 personalContact">
                                                        <p class="">Contact Details</p>
                                                    </div>
                                                    <div class="d-flex mt-4 gap-3">
                                                        <div class="d-flex flex-column">
                                                            <label for="strAddress">Address*</label>
                                                            <input type="text" id="strAddress" class="commonNameStyle setGenderWidth" name="strAddress" placeholder="Your Address" >
                                                        </div>
                                                        <div class="d-flex flex-column">
                                                            <label for="strStreet">Street*</label>
                                                            <input type="text" id="strStreet" class="commonNameStyle setDateWidth" name="strStreet" placeholder="Your Street Name" >
                                                        </div>
                                                    </div>
                                                    <div class="d-flex mt-4 gap-3">
                                                        <div class="d-flex flex-column">
                                                            <label for="strEmail">Email*</label>
                                                            <input type="text" id="strEmail" class="commonNameStyle setGenderWidth" name="strEmail" placeholder="Your Email" >
                                                        </div>
                                                        <div class="d-flex flex-column">
                                                            <label for="strPhone">Phone*</label>
                                                            <input type="text" id="strPhone" class="commonNameStyle setDateWidth" name="strPhone" placeholder="Your Phone Number" >
                                                        </div>
                                                    </div>
                                                    <div class="d-flex mt-4">
                                                        <button type="submit" id="btnSubmit" class="btn btn-primary m-0 ms-5" data-bs-dismiss="modal">SUBMIT</button>
                                                        <button type="button" class="btn btn-primary m-0 ms-5" data-bs-dismiss="modal">CLOSE</button>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                        <div class="px-5 createContactImgSection">
                                            <img src="./assets/images/createContact.PNG" alt=""  class="">
                                        </div>
                                    </div>
                                    <!---end--->
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div>
                </div>

                <div class="dataListingSection">
                    <table border="0">
                        <tr>
                            <div>
                                <div><th>NAME</th></div>
                                <div><th>EMAIL ID</th></div>
                                <div><th>PHONE NUMBER</th></div>
                            </div>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </body>
</cfoutput>
</html>

