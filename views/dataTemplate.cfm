<cfoutput>
    <cfset contacts = EntityLoad("ContactsTable")>
    <cfset excelQuery = queryNew("Title,FirstName,LastName,Gender,DOB,Photo,Address,Street,Pincode,Email,Phone,Hobbies","varchar,varchar,varchar,varchar,date,varchar,varchar,varchar,varchar,varchar,varchar,varchar")> 
    <cfset getHobbies = function(contact) {
        var hobbyLinks = EntityLoad("ContactHobbyLinkTable", {contactId=contact});
        var hobbies = arrayMap(hobbyLinks, function(hobbyLink) {
            return EntityLoadByPK("HobbysTable", hobbyLink.getHobbyId()).getHobbies();
        });
        return arrayToList(hobbies, ',');
    }>
    <cfset addContactToQuery = function(contact) {
        var local = {};
        local.title = contact.getTitle();
        local.firstName = contact.getFirstName();
        local.lastName = contact.getLastName();
        local.gender = contact.getGender();
        local.dob = contact.getDOB();
        local.photo = contact.getPhoto();
        local.address = contact.getAddress();
        local.street = contact.getStreet();
        local.pincode = contact.getPincode();
        local.email = contact.getEmail();
        local.phone = contact.getPhone();
        local.hobbies = getHobbies(contact);
        queryAddRow(excelQuery, 1);
        querySetCell(excelQuery, "Title", local.title);
        querySetCell(excelQuery, "FirstName", local.firstName);
        querySetCell(excelQuery, "LastName", local.lastName);
        querySetCell(excelQuery, "Gender", local.gender);
        querySetCell(excelQuery, "DOB", local.dob);
        querySetCell(excelQuery, "Photo", local.photo);
        querySetCell(excelQuery, "Address", local.address);
        querySetCell(excelQuery, "Street", local.street);
        querySetCell(excelQuery, "Pincode", local.pincode);
        querySetCell(excelQuery, "Email", local.email);
        querySetCell(excelQuery, "Phone", local.phone);
        querySetCell(excelQuery, "Hobbies", local.hobbies);
    }>
    <cfset sortContacts = arrayFilter(contacts, function(contact) {
        return session.UserId eq contact.getAdminId();
    })>
    <cfset arrayEach(sortContacts, addContactToQuery)>
    <cfif session.getAction EQ "sheet">
        <cfset excelPath = ExpandPath("./User_Details.xlsx")>
        <cfspreadsheet action="write" filename="#excelPath#" query="excelQuery" sheetname="contacts">
        <cfheader name="Content-Disposition" value="attachment; filename=User_Details.xlsx">
        <cfcontent type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" file="#excelPath#" deleteFile="true">
    <cfelseif session.getAction EQ "data">
        <cfset excelPath = ExpandPath("./Template_with_data.xlsx")>
        <cfspreadsheet action="write" filename="#excelPath#" query="excelQuery" sheetname="contacts">
        <cfheader name="Content-Disposition" value="attachment; filename=Template_with_data.xlsx">
        <cfcontent type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" file="#excelPath#" deleteFile="true">
    </cfif>
</cfoutput>
