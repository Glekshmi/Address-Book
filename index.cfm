<cfscript>
    cfparam(name="url.action", default="login", pattern="");
    session.getAction = url.action;

    if (lcase(url.action) eq "login") {
        include "/views/header.cfm";
        include "/views/navbar.cfm";
        include "/views/login.cfm";
    }
    else if (lcase(url.action) eq "signup") {
        include "/views/header.cfm";
        include "/views/navbar.cfm";
        include "/views/signUp.cfm";
    }
    else if (lcase(url.action) eq "display") {
        include "/views/header.cfm";
        include "/views/listingPage.cfm";
    }
    else if (lcase(url.action) eq "pdf") {
        include "/views/header.cfm";
        include "/views/listingPagePdf.cfm";
    }
    else if (lcase(url.action) eq "data" or lcase(url.action) eq "sheet") {
        include "/views/dataTemplate.cfm";
    }
    else if (lcase(url.action) eq "plain") {
        include "/views/plainTemplate.cfm";
    }
    else if (lcase(url.action) eq "download") {
        include "/views/result.cfm";
    }
    else if (lcase(url.action) eq "error") {
        include "/views/header.cfm";
        include "/views/errorPage.cfm";
    }
    else if (lcase(url.action) eq "logout") {
        include "/views/login.cfm";
    }
    
</cfscript>