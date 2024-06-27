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
                include "/views/header.cfm";
                include "/views/errorPage.cfm";
            break;

            case "data":
                include "/views/header.cfm";
                include "/views/dataTemplate.cfm";
            break;

            case "plain":
                include "/views/header.cfm";
                include "/views/plainTemplate.cfm";
            break;

            case "download":
                include "/views/header.cfm";
                include "/views/result.cfm";
            break;

            case "logout":
                include "/views/login.cfm";
            break;

            default:
            break;
        }
  
</cfscript>