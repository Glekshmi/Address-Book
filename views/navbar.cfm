<cfset variables.strLoginLink=''>
<cfset variables.strSignUpLink=''>
<cfset variables.strLogImg=session.userLoggedIn?"logout":"login">
<cfset variables.strSignUpImg=session.userLoggedIn?"":"person">
<!--- <cfset variables.strLoginLink= session.userLoggedIn?"Logout":"Login"> --->
<cfset variables.strSignUpLink= session.userLoggedIn?"":"Sign Up">
<cfoutput>
	<nav class="navbar navbar-expand-lg navbarStyle">
		<div class="container-fluid">
			<div class="navLogoTitle">
				<a href="?action=login">
					<img src="./assets/images/contact-book.png" alt="" width="40" height="40" class="d-inline-block align-text-top">
				</a>
				<a class="navbar-brand" href="?action=login">
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
						<span class="material-symbols-outlined navbarLogIcon">#variables.strSignUpImg#</span>
						<a class="navLinks" href="?action=signup">#variables.strSignUpLink#</a>
					</div>
					<div class="d-flex">
						<span class="material-symbols-outlined navbarLogIcon">#variables.strLogImg#</span>
						<a class="navLinks" href="?action=login">Login</a>
					</div>
				</div>
			</div>
		</div>
	</nav>
</cfoutput>