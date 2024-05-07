<cfscript>
    cfparam(name="url.action", default="display", pattern="");

    switch(lcase(url.action)){
        case "login":
            include "/views/login.cfm";
        break;

        case "signup":
            include "/views/signUp.cfm";
        break;

        case "display":
            include "/views/listingPage.cfm";
        break;

        // The provided event could not be matched.
        default:
           // throw( type="InvalidEvent" );
           //include "/views/signUp.cfm";
        break;
    }
</cfscript>