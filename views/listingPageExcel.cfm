<cfcontent type="application/msexcel">
<cfheader name="Content-Disposition" value="filename=excelSheet.csv">

<cfoutput>
    <!--- Header row --->
    "NAME", "EMAIL ID", "PHONE NUMBER",

    <!--- Data rows --->
    <cfset contacts = EntityLoad("ContactsTable")>
    <cfloop array="#contacts#" index="data">
        <cfif session.UserId EQ data.getAdminId()>
            <cfoutput>
                "#data.getFirstName()# #data.getLastName()#", "#data.getEmail()#", "#data.getPhone()"#,
            </cfoutput>
        </cfif>
    </cfloop>
</cfoutput>
