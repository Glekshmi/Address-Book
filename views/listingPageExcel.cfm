<cfoutput>
    <cfset contacts = EntityLoad("ContactsTable")>
    <cfset excelQuery = queryNew("Title,FirstName,LastName,Gender,DOB,Photo,Address,Street,Pincode,Email,Phone,Hobbies","varchar,varchar,varchar,varchar,date,varchar,varchar,varchar,varchar,varchar,varchar,varchar")> 
    <cfloop array="#contacts#" index="contact">
        <cfif session.UserId Eq contact.getAdminId()>
            <cfset local.title = contact.getTitle()>
            <cfset local.firstName = contact.getFirstName()>
            <cfset local.lastName = contact.getLastName()>
            <cfset local.gender = contact.getGender()>
            <cfset local.dob = contact.getDOB()>
            <cfset local.photo = contact.getPhoto()>
            <cfset local.address = contact.getAddress()>
            <cfset local.street = contact.getStreet()>
            <cfset local.pincode = contact.getPincode()>
            <cfset local.email = contact.getEmail()>
            <cfset local.phone = contact.getPhone()>
            <cfset hobby = EntityLoad("ContactHobbyLinkTable",{contactId=contact})>
            <cfset hobbies = ''>
            <cfloop array="#hobby#" index="hobbysList">
                <cfset hobbyList = EntityLoadByPK("HobbysTable", hobbysList.getHobbyId())>
                <cfset hobbies &= hobbyList.getHobbies()&','>
            </cfloop>  
            <cfset queryAddRow(excelQuery, 1)>
            <cfset querySetCell(excelQuery, "Title", local.title)>
            <cfset querySetCell(excelQuery, "FirstName", local.firstName)>
            <cfset querySetCell(excelQuery, "LastName", local.lastName)>
            <cfset querySetCell(excelQuery, "Gender", local.gender)>
            <cfset querySetCell(excelQuery, "DOB", local.dob)>
            <cfset querySetCell(excelQuery, "Photo", local.photo)>
            <cfset querySetCell(excelQuery, "Address", local.address)>
            <cfset querySetCell(excelQuery, "Street", local.street)>
            <cfset querySetCell(excelQuery, "Pincode", local.pincode)>
            <cfset querySetCell(excelQuery, "Email", local.email)>
            <cfset querySetCell(excelQuery, "Phone", local.phone)>
            <cfset querySetCell(excelQuery, "Hobbies", hobbies)>
        </cfif>
    </cfloop>
    <cfset excelPath = ExpandPath("./contactDetail.xlsx")>
    <cfspreadsheet action="write" filename="#excelPath#" query="excelQuery" sheetname="contacts">
    <cfheader name="Content-Disposition" value="attachment; filename=contactDetail.xlsx">
    <cfcontent type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" file="#excelPath#" deleteFile="true">
</cfoutput>