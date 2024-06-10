<cfscript>

    cfparam(name="url.action", default="login", pattern="");
    urlSegments = listToArray(url.action, ',');
    last = arrayLast(urlSegments);
    arrLen = arrayLen(urlSegments);
    // fullURL = "http://#cgi.server_name##cgi.script_name##cgi.query_string#";
    // queryString = "#cgi.query_string#";
    // parameters = ListToArray(queryString, "&");
    // lastParameter = parameters[ArrayLen(parameters)];
    // lastParameterParts = ListToArray(lastParameter, "=");
    // lastWord = lastParameterParts[2];
    // serverName = "#cgi.server_name#";
    // scriptName = "#cgi.script_name#";
    // newURL = "http://" & serverName & scriptName & lastWord;
    // writeDump(fullURL); 
    // writeDump(lastWord);
    // writeDump(newURL);
    // if(arrLen>1){
    //     switch(lcase(last)){
    //         case "login":
    //             include "/views/header.cfm";
    //             include "/views/navbar.cfm";
    //             include "/views/login.cfm";
    //         break;

    //         case "signup":
    //             include "/views/header.cfm";
    //             include "/views/navbar.cfm";
    //             include "/views/signUp.cfm";
    //         break;

    //         case "display":
    //             include "/views/header.cfm";
    //             include "/views/listingPage.cfm";
    //         break;

    //         case "pdf":
    //             include "/views/header.cfm";
    //             include "/views/listingPagePdf.cfm";
    //         break;

    //         case "sheet":
    //             include "/views/header.cfm";
    //             include "/views/listingPageExcel.cfm";
    //         break;

    //         case "error":
    //             include "/views/errorPage.cfm";
    //         break;


    //         case "logout":
    //             include "/views/login.cfm";
    //         break;

    //         default:
    //         break;
    //     }
    // }
    // else{
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
                include "/views/errorPage.cfm";
            break;


            case "logout":
                include "/views/login.cfm";
            break;

            default:
            break;
        }
    // }
</cfscript>