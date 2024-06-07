<cfoutput>
	<cfset myComponent = createObject("component", "controllers/addressBook").login()>
	<div class="container ">
		<div class="row loginContainer d-flex justify-content-center">
			<div class="col-2 loginSectionImg">
				<img src="./assets/images/contact-book.png" alt=""  width="100" height="100" class="d-inline-block align-text-top">
			</div>
			<div class="col-4 loginSectionContent">
				<p class="loginTitle">LOGIN</p>
				<p id="validationMsg" class="validationMsg"></p>
				<br>
				<form action="?action=login" method="post">
					<div class="input-field">
						<input type="text" name="strEmail" id="email" placeholder="email">  
					</div>
					<div class="input-field inputFieldBottom">
						<input type="password" name="strPassword" id="password" placeholder="password">
					</div>
					<br>
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
				<div class="loginBtnSection">
					<p>Don't have an account?<a href="/signup">Register here.</a></p>
				</div>
			</div>
		</div>
	</div>
	</body>
	</html>
</cfoutput>