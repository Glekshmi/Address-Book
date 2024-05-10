<cfscript>
    cfparam(name="url.action", default="login", pattern="");

    switch(lcase(url.action)){
        case "login":
            include "/views/header.cfm";
            include "/views/login.cfm";
        break;

        case "signup":
             include "/views/header.cfm";
            include "/views/signUp.cfm";
        break;

        case "display":
             include "/views/header.cfm";
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

        case "logout":
            include "/views/newContact.cfm";
        break;


        // The provided event could not be matched.
        default:
           // throw( type="InvalidEvent" );
           //include "/views/pdfFile.cfm";
        break;
    }
</cfscript>