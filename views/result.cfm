<cfoutput>
<cfif session.downloadFilePath NEQ "">
    <cfheader name="Content-Disposition" value="attachment; filename=Upload_Result.xlsx">
    <cfcontent file="#session.downloadFilePath#" type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" deleteFile="true">
</cfif>
</cfoutput>
