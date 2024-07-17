<cfoutput>
	<cfif session.userLoggedIn>
		<cfset variables.profilePhoto = session.profileURL?session.profile:"./assets/uploads/"&session.photo>
		<nav class="navbar navbar-expand-lg navbarStyle">
			<div class="container-fluid">
				<div class="navLogoTitle">
					<a href="/display">
						<img src="./assets/images/contact-book.png" alt="" width="40" height="40" class="d-inline-block align-text-top">
					</a>
					<a class="navbar-brand" href="/display">
						<h3 class="logoTitle">ADDRESS BOOK</h3>
					</a>
				</div>
				<button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="navbarText" aria-controls="navbarText" aria-expanded="false" aria-label="Toggle navigation">
					<span class="navbar-toggler-icon"></span>
				</button>
				<div class="collapse navbar-collapse" id="navbarText">
					<ul class="navbar-nav me-auto mb-2 mb-lg-0"></ul>
					<div class="d-flex gap-4">
						<div class="d-flex">
							<span class="material-symbols-outlined navbarLogIcon">logout</span>
							<a class="navLinks logoutLink" href="./controllers/addressBook.cfc?method=logout">Logout</a>
						</div>
					</div>
				</div>
			</div> 
		</nav>
		<div class="listingPageSection">
			<div class="topDownloadBar gap-2">  
				<a href="/pdf" target="_blank">  
					<img src="./assets/images/pdf.PNG" alt="Download PDF" width="30" height="32" class="d-inline-block align-text-top logoutImg">
				</a>
				<a href="/sheet" target="_blank">
					<img src="./assets/images/excel.PNG" alt="" width="26" height="32" class="d-inline-block align-text-top logoutImg">
				</a>
				<a>
					<img src="./assets/images/printer.PNG" alt="" width="32" height="34" id="print" class="d-inline-block align-text-top logoutImg">
				</a>
			</div>
			<div class="midSection">
				<div class="createContactSection">
					<div class="loginUserImg">
						<img src="#variables.profilePhoto#" alt="" width="20" height="20" class="d-inline-block align-text-top">
					</div>
					<div class="loginUserName">
						<p class="tableField">#UCase(session.UserName)#</p>
					</div>
					<div class="d-flex flex-column justify-content-center align-items-center gap-2">
						<button type="button" class="btn btn-primary p-2 createBtn m-0" id="createContactBtn" data-bs-toggle="modal" data-bs-target="##myModal">CREATE CONTACT</button>
						<button type="button" class="btn btn-primary p-2 createBtn m-0" id="uploadContactBtn" data-bs-toggle="modal" data-bs-target="##uploadModal">UPLOAD FILE</button>
					</div>
				</div>
				<div>
				</div>
				<div class="dataListingSection">
					<div class="tableStyle" id="printContent">
						<table class="dataTable col-12">
							<thead>
								<tr class="text-primary tableRowStyle">
									<th class="tableField FieldFontSize"></th>
									<th class="tableField tableField2 FieldFontSize word-wrap">NAME</th>
									<th class="tableField FieldFontSize">EMAIL ID</th>
									<th class="tableField FieldFontSize">PHONE NUMBER</th>
									<th></th>
									<th></th>
									<th></th>
								</tr>
							</thead>
							<tbody>
								<cfset contacts = EntityLoad("ContactsTable")>
								<cfloop array="#contacts#" index="data">
									<cfset  contactId= data.getUserId()>
									<cfif session.UserId EQ data.getAdminId()>
										<div>
											<tr>
												<td><img src="./assets/uploads/#data.getPhoto()#" alt="image" width="30" height="30"></td>
												<td class="setRowWidth">#data.getFirstName()# #data.getLastName()#</td>
												<td>#data.getEmail()#</td>
												<td>#data.getPhone()#</td>
												<th><button type="button" class="btn btn-outline-primary viewBtn  m-0 btnEdit" id="clearEditForm" data-id="#contactId#" data-bs-toggle="modal" data-bs-target="##myModal">EDIT</button></th>
												<th><button type="button" class="btn btn-outline-primary viewBtn btnDelete m-0" data-id="#contactId#" data-bs-toggle="modal" data-bs-target="##deleteModal">DELETE</button></th>
												<th><button type="button" class="btn btn-outline-primary viewBtn btnView m-0" data-id="#contactId#" data-bs-toggle="modal" data-bs-target="##viewModal">VIEW</button></th>
											</tr>
										</div>
									</cfif>
								</cfloop>
							</tbody>
						</table>
						<div class="modal bd-example-modal-lg fade contactPopUp" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true" id="myModal">
							<div class="modal-dialog modal-lg p-1">
								<div class="modal-content ps-3 outerContainer">
									<div class="d-flex justify-content-between">
										<div class="popupContactHeader">
											<div  class="d-flex justify-content-center subHeader">
												<p class="contactMainTitle" id="setTitle"></p>
											</div>
											<div class="d-flex personalContact commonStyle">
												<p class="">Personal Contact</p>
											</div>
											<div class="commonStyle contactFormSection">
												<form action="" method="post" id="submitForm" enctype="multipart/form-data">
													<div class="firstNameSection d-flex">
														<div class="d-flex flex-column ">
															<label for="strTitle">Title*</label>
															<select name ="strTitle" id="strTitle" class="selectTitle commonInputStyle">
																<option selected value=""></option>
																<option value="Miss">Miss</option>
																<option value="Mr">Mr</option>
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
															<select name ="strGender" id="strGender" class="selectTitle commonNameStyle setGenderWidth">
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
														<div class="d-flex flex-column">
															<div class="photoStyle">
																<p class="mb-1">Upload Photo</p>
															</div>
															<div class="file-upload-wrapper">
																<input type="file" id="imagePath" name="imagePath">
																<div class="d-flex align-items-center">
																	<div class="file-upload-button">Choose File</div>
																	<p id="fileName"></p>
																</div>
															</div>
														</div>
													</div>
												</div>
												<div class="position-relative contactDetailsContainer">
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
															<label for="strPincode">Pincode*</label>
															<input type="text" id="strPincode" class="commonNameStyle setDateWidth" name="strPincode" placeholder="Your Pincode" >
														</div>
														<div class="d-flex flex-column">
															<label for="strEmail">Email*</label> 
															<input type="text" id="strEmail" class="commonNameStyle setGenderWidth" name="strEmail" placeholder="Your Email" >
														</div>
													</div>
													<div class="d-flex mt-4 gap-3">
														<div class="d-flex flex-column">
															<label for="strPhone">Phone*</label>
															<input type="text" id="strPhone" class="commonNameStyle setDateWidth" name="strPhone" value="+91" placeholder="Your Phone Number" >
														</div>
														<div class="d-flex flex-column">
															<label for="strPhone">Hobbies*</label>
															<div class="hobbieDropdown" id="hobbies">
																<div class="select-box">Select Options</div>
																<select id="optionsList" multiple></select>
															</div>
														</div>
													</div>		
													
													<div class="d-flex ms-5 gap-5 mt-5">
														<input type="hidden" id="hiddenId" value="0">
														<button type="submit" class="btn btn-primary " >SUBMIT</button>
														<button type="button" class="btn btn-primary" data-bs-dismiss="modal">CLOSE</button>
													</div>
													<div>
														<h5 id="contactValidationMsg"></h5>
													</div>
												</div>
											</form>
										</div>
										<div class="px-5 createContactImgSection">
											<img src="./assets/images/createContact.PNG" alt="" width="50" height="50" id="filePhoto">
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="modal bd-example-modal-lg fade contactPopUp" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true" id="uploadModal">
						<div class="modal-dialog modal-lg p-1">
							<div class="modal-content ps-3 uploadContainer">
								<div class="d-flex ">
									<div class="uploadPopup">
										<div class="d-flex align-items-baseline justify-content-end p-2 gap-1">
											<button class="btn p-1 btnTemplate btnData"><a href="/data" target="_blank" class="excelTemplate">Template with data</a></button>
											<button class="btn p-1 btnTemplate btnPlain"><a href="/plain" target="_blank" class="excelTemplate">Plain template</a></button>
											<button class="btn btn-info p-1 btnTemplate"><a href="/download" target="_blank" class="excelTemplate">Upload Result</a></button>
										</div>
										<div  class="d-flex subHeader">
											<p class="contactMainTitle" id="setTitle">UPLOAD CONTACT</p>
										</div>
										<div class="commonStyle contactFormSection">
											<form action="" method="post" id="submitExcel" enctype="multipart/form-data">
												<div class="lastNameSection d-flex flex-column">
													<div class="d-flex flex-column">
														<div class="photoStyle">
															<p class="mb-1">Upload Photo</p>
														</div>
														<input type="file" id="fileExcel" name="fileExcel" class="pt-1 pb-1">
													</div>
												</div>
												<div class="d-flex mt-4">
													<input type="hidden" id="hiddenId" value="0">
													<button type="submit" class="btn btn-primary m-0 me-4">SUBMIT</button>
													<button type="button" class="btn btn-primary m-0 ms-5" data-bs-dismiss="modal">CLOSE</button>
												</div>
											</form>
											<div>
												<p id="excelValidationMsg" class="excelErrorMsg"></p>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="modal bd-example-modal-lg fade contactPopUp" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" class="viewButton" aria-hidden="true" id="viewModal">
						<div class="modal-dialog modal-lg p-1">
							<div class="modal-content ps-3 outerContainer">
								<div class="d-flex justify-content-between ">
									<div class="popupContactHeader">
										<div  class="d-flex justify-content-center subHeader">
											<p class="contactMainTitle">CONTACT DETAILS</p>
										</div>
										<div class="displayContact">
											<div class="d-flex">
												<div class="d-flex col-3 justify-content-between">
													<p class="contactTextColor viewField viewOuterTag">Name</p>
													<p class="contactTextColor viewField viewInnerTag viewName">:</p>
													&nbsp
												</div>
												<p id="name" class="contactTextColor viewField word-wrap"></p>
												&nbsp
											</div>
											<div class="d-flex">
												<div class="d-flex col-3 justify-content-between">
													<p class="contactTextColor viewField viewOuterTag">Gender</p>
													<p class="contactTextColor viewField viewInnerTag viewGender">:</p>
													&nbsp
												</div>
												<p id="gender" class="contactTextColor viewField"></p>
											</div>
											<div class="d-flex">
												<div class="d-flex col-3 justify-content-between">
													<p class="contactTextColor viewField viewOuterTag">Date Of Birth</p>
													<p class="contactTextColor viewField viewInnerTag">:</p>
													&nbsp
												</div>
												<p id="dob" class="contactTextColor viewField"></p>
											</div>
											<div class="d-flex">
												<div class="d-flex col-3 justify-content-between">
													<p class="contactTextColor viewField viewOuterTag">Address</p>
													<p class="contactTextColor viewField viewInnerTag viewAddress">:</p>
													&nbsp
												</div>
												<p id="address" class="contactTextColor viewField"></p>
											</div>
											<div class="d-flex">
												<div class="d-flex col-3 justify-content-between">
													<p class="contactTextColor viewField viewOuterTag">Pincode</p>
													<p class="contactTextColor viewField viewInnerTag viewPincode">:</p>
													&nbsp
												</div>
												<p id="pincode" class="contactTextColor viewField"></p>
											</div>
											<div class="d-flex">
												<div class="d-flex col-3 justify-content-between">
													<p class="contactTextColor viewField viewOuterTag">Email Id</p>
													<p class="contactTextColor viewField viewInnerTag viewEmail">:</p>
													&nbsp
												</div>
												<p id="email" class="contactTextColor viewField"></p>
											</div>
											<div class="d-flex">
												<div class="d-flex col-3 justify-content-between">
													<p class="contactTextColor viewField viewOuterTag">Phone</p>
													<p class="contactTextColor viewField viewInnerTag viewPhone">:</p>
													&nbsp
												</div>
												<p id="phone" class="contactTextColor viewField"></p>
											</div>
											<div class="d-flex">
												<div class="d-flex col-3 justify-content-between">
													<p class="contactTextColor viewField viewOuterTag">Hobbies</p>
													<p class="contactTextColor viewField viewInnerTag viewPhone">:</p>
													&nbsp
												</div>
												<p id="hobby" class="contactTextColor viewField"></p>
											</div>
											<div class="d-flex pt-5 ps-5">
												<div class="btnViewClose">
													<button type="button" class="btn btn-primary btnViewClose" data-bs-dismiss="modal">CLOSE</button>
												</div>
											</div>
										</div>
									</div>
									<div class="px-5 createContactImgSection">
										<img src="" alt=""  id="photo" width="40" height="40">
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="modal fade" id="deleteModal" tabindex="-1" role="dialog" aria-labelledby="deleteModalLabel" aria-hidden="true">
						<div class="modal-dialog" role="document">
							<div class="modal-content">
								<div class="modal-header">
									<h5 class="modal-title" id="deleteModalLabel">Confirm Deletion</h5>
								</div>
								<div class="modal-body">
									Are you sure you want to delete this item?
								</div>
								<div class="modal-footer">
									<button type="submit" class="btn btn-danger m-0 me-4 confirmDeleteBtn"  data-id="#contactId#" data-bs-dismiss="modal">SUBMIT</button>
									<button type="button" class="btn btn-primary m-0 ms-5" data-bs-dismiss="modal">CLOSE</button>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		</div>
	 	<!--<script> 
        $(document).ready(function() {
            $(".strHobbies").select2({
                placeholder: "Select hobbies",
                tags: true
            });
        })
    </script>-->
		</body>
	<cfelse>
		<cflocation  url="/login" addToken = false>
	</cfif>
</cfoutput>
</html>