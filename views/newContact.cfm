<cfinclude  template="header.cfm">
<button type="button" class="createContact m-0" data-bs-toggle="modal" data-bs-target="##myModal">CREATE CONTACT</button>
            <div class="modal bd-example-modal-lg fade" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true" id="myModal">
                <div class="modal-dialog modal-lg p-1">
                    <div class="modal-content d-flex ps-3 formBorder">
                        <div class="d-flex justify-content-between gap-3">
                            <div class="ps-5 py-5 d-flex flex-column justify-content-between formSide gap-3">
                            
                                <div class="d-flex align-items-center justify-content-center addMsgStyle p-2">
                                    <h5 class="mb-0" id="addMsg"><b></b></h5>
                                </div>
                                <div class="createAccount d-flex align-items-center justify-content-center p-2">
                                    <h4 class="mb-0"><b>CREATE ACCOUNT</b></h4>
                                </div>
                                <div class="personalContact">
                                    <h4 class="mb-0">Personal Contact</h4>
                                </div>
                                <form action="" method="post"  enctype="multipart/form-data">
                                    <div class="formData d-flex flex-column gap-4">
                                        <div class="d-flex gap-3">
                                            <div class="d-flex flex-column">
                                                <label for="strTitle">Title*</label>
                                                <div class="dropdown d-flex justify-content-start">
                                                    <select id="strTitle" name ="strTitle" class="form-select form-select-sm">
                                                        <option selected value=""></option>
                                                        <option value="Miss" <cfif variables.strTitle eq "Miss">selected</cfif> >Miss</option>
                                                        <option value="Mister" <cfif variables.strTitle eq "Mister">selected</cfif> >Mister</option>
                                                    </select>
                                                </div> 
                                            </div>
                                            <div class="nameInput d-flex flex-column">                                            
                                                <label for="strFirstName">First Name*</label>
                                                <input type="text" id="strFirstName" name="strFirstName" placeholder="Your First Name" value="#variables.strFirstName#">
                                            </div>
                                            <div class="nameInput d-flex flex-column">                                            
                                                <label for="strLastName">Last Name*</label>
                                                <input type="text" id="strLastName" name="strLastName" placeholder="Your Last Name" value="#variables.strLastName#">
                                            </div>
                                        </div>
                                        <div class="d-flex gap-3">
                                            <div class="d-flex flex-column">
                                                <label for="strGender">Gender*</label>
                                                <div class="dropdown d-flex justify-content-start">
                                                    <select id="strGender" name = "strGender" class="form-select form-select-sm">
                                                        <option selected value=""></option>
                                                        <option value="Male" <cfif variables.strGender eq "Male">selected</cfif> >Male</option>
                                                        <option value="Female" <cfif variables.strGender eq "Female">selected</cfif> >Female</option>
                                                        <option value="Other" <cfif variables.strGender eq "Other">selected</cfif> >Other</option>
                                                    </select>
                                                </div> 
                                            </div>
                                            <div class="d-flex flex-column">                                            
                                                <label for="strDate">Date Of Birth*</label>
                                                <input type="date" id="strDate" name="strDate" value="#variables.strDate#">
                                            </div>
                                        </div>
                                        <div class="d-flex gap-3">
                                            <div class="d-flex flex-column ">                                            
                                                <label class="fs-7" for="strUploadFile">Upload Photo*</label>
                                                <input type="file" id="strUploadFile" name="strUploadFile"  value="#variables.strUploadFile#">
                                            </div>
                                        </div>
                                    </div>
                                </form>
                                <div class="contactHead ">
                                    <h4 class="mb-0 fs-5 ">Contact Details</h4>
                                </div>
                                <div class="d-flex gap-3">
                                    <div class="addressInput d-flex flex-column">
                                        <label for="strAddress">Address*</label>
                                        <input type="text" id="strAddress" name="strAddress" value="#variables.strAddress#">
                                    </div>
                                    <div class="addressInput d-flex flex-column">
                                        <label for="strStreet">Street*</label>
                                        <input type="text" id="strStreet" name="strStreet" value="#variables.strStreet#">
                                    </div>
                                </div>
                                <div class="d-flex gap-3">
                                    <div class="addressInput d-flex flex-column">
                                        <label for="intPhoneNumber">Phone Number*</label>
                                        <input type="text" id="intPhoneNumber" name="intPhoneNumber" value="#variables.intPhoneNumber#">
                                    </div>
                                    <div class="addressInput d-flex flex-column">
                                        <label for="strEmailId">Email*</label>
                                        <input type="text" id="strEmailId" name="strEmailId" value="#variables.strEmailId#">
                                    </div>
                                </div>
                                <div class="d-flex gap-3">
                                    <div class="addressInput d-flex flex-column">
                                        <label for="intPinCode">Pincode*</label>
                                        <input type="text" id="intPinCode" name="intPinCode" value="#variables.intPinCode#">
                                    </div>
                                </div>
                                <div class="d-flex align-items-center justify-content-start gap-5">
                                    <button type="button" class="createContact closeBtn m-0 me-4" id="formSubmit">SUBMIT</button>
                                    <button type="button" class="createContact closeBtn m-0 ms-5" data-bs-dismiss="modal">CLOSE</button>
                                </div>
                            </div>
                            <div class="modalProfile d-flex align-items-center justify-content-center p-5">
                                <img src="./assets/images/modalProfile.png" class="userProfile " alt="userProfile">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
</body>
</html>