

<cfoutput>
    <html>
    <head>
        <title>Download PDF</title>
    </head>
    <body>
        <h1>Download PDF</h1>
        <a href="#CGI.SCRIPT_NAME#?downloadPDF=true">
            <img src="./assets/images/pdf.png" alt="Download PDF">
        </a>
        
        <cfif structKeyExists(url, "downloadPDF") and url.downloadPDF eq "true">
            <cfdocument format="pdf" filename="mypage.pdf">
                <h2>This is a test PDF content.</h2>
            </cfdocument>
        
            <cfheader name="Content-Disposition" value="attachment; filename=mypage.pdf">
            <cfcontent type="application/pdf" file="mypage.pdf">
        </cfif>
    </body>
    </html>
</cfoutput>
