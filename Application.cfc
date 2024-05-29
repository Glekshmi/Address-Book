component 
	output="false"
	hint="I define the application settings and event handlers."
	{
	this.baseDirectory = getDirectoryFromPath( getCurrentTemplatePath() );
	this.name = hash( this.baseDirectory );
	this.applicationTimeout = createTimeSpan( 0, 1, 0, 0 );
	this.sessionManagement = true;
	this.sessionTimeout = createTimeSpan( 0, 0, 10, 0 );
	this.mappings[ "/models" ] = (this.baseDirectory & "models/");
	this.mappings[ "/views" ] = (this.baseDirectory & "views/");
	this.mappings[ "/controllers" ] = (this.baseDirectory & "controllers/");
	this.mappings[ "/layouts" ] = (this.baseDirectory & "layouts/");

	
	this.name="ContactsTable";
	this.ormEnabled="true";
	this.dataSource="coldfusionDb";
	

	function onApplicationStart(){
		return( true );
	}
	function onSessionStart(){
		session.result = {};
		session.userLoggedIn = false;
		session.UserId = '';
		session.UserName = '';
		session.adminEmail = '';
		session.photo = '';
		session.profile = '';
		session.fullName = '';
		session.profileURL=false;
	}
	function onRequestStart( String scriptName ){
		if (structKeyExists( url, "init" )){
			this.onApplicationStart();
			this.onSessionStart();
			
		}
		ORMReload();
		request.event = [];
		if (
			!isNull( url.event ) &&
			len( trim( url.event ) )
			){
			request.event = listToArray( trim( url.event ), "." );

		}
		request.viewData = {};
		return( true );
	
	}
	function onRequest( String scriptName ){
		include "./index.cfm";		

	}
	function onError( Any error, String eventName ){
		writeDump( error );
		abort;
	}	
}