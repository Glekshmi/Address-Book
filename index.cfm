<cfscript>
    cfparam(name="url.action", default="login", pattern="");

    switch(lcase(url.action)){
        case "login":
            include "/views/header.cfm";
            include "/views/navbar.cfm";
            include "/views/login.cfm";
        break;

        case "signup":
            include "/views/header.cfm";
            include "/views/navbar.cfm";
            include "/views/signUp.cfm";
        break;

        case "display":
            include "/views/header.cfm";
            include "/views/navbar.cfm";
            include "/views/listingPage.cfm";
        break;

        case "pdf":
            include "/views/header.cfm";
            include "/views/listingPagePdf.cfm";
        break;

        case "sheet":
            include "/views/header.cfm";
            include "/views/listingPageExcel.cfm";
        break;

        case "error":
            include "/views/errorPage.cfm";
        break;


        case "logout":
            include "/views/login.cfm";
        break;


        // The provided event could not be matched.
        default:
           // throw( type="InvalidEvent" );
           //include "/views/dummy.cfm";
        break;
    }
</cfscript>