
<cfoutput>
<cfset contacts = EntityLoad("ContactsTable")>
<cfset excelQuery = queryNew("Title,FirstName,LastName,Gender,DOB,Photo,Address,Street,Pincode,Email,Phone,Hobbies","varchar,varchar,varchar,varchar,date,varchar,varchar,varchar,varchar,varchar,varchar,varchar")> 
<cfset filePath = ExpandPath("./Plain_Template.xlsx")>
<cfspreadsheet action="write" filename="#filePath#" query="excelQuery" sheetname="contacts">
<cfheader name="Content-Disposition" value="attachment; filename=Plain_Template.xlsx">
<cfcontent file="#filePath#" type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet">
</cfoutput>
