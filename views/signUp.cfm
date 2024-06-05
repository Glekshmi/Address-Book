<cfoutput>
	<cfset myComponent = createObject("component", "controllers/addressBook").login()>
	<div class="container ">
		<div class="row loginContainer">
			<div class="col-2 loginSectionImg signInSection">
				<img src="./assets/images/contact-book.png" alt=""  width="100" height="100" class="d-inline-block align-text-top">
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
					<div class="input-field inputFieldBottom">
						<input type="file" name="strPhoto" id="photo">
					</div>
					<div class="loginBtnSection">
						<button type="submit" class="btn btn-outline-primary btnSubmit registerBtn" id="registerBtn">REGISTER</button>
					</div>
				</form>
			</div>
		</div>
	</div>
</cfoutput>
</body>
</html>