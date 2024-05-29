
<cfoutput>
    <cfhtmltopdf>
        <table class="w-100">
            <thead>
                <tr class="text-primary">
                    <th class="tableField FieldFontSize">Photo</th>
                    <th class="tableField FieldFontSize">Name</th>
                    <th class="tableField FieldFontSize">Gender</th>
                    <th class="tableField FieldFontSize">DOB</th>
                    <th class="tableField FieldFontSize">Address</th>
                    <th class="tableField FieldFontSize">Street</th>
                    <th class="tableField FieldFontSize">Pincode</th>
                    <th class="tableField FieldFontSize">Email</th>
                    <th class="tableField FieldFontSize">Phone</th>
                </tr>
            </thead>
            <tbody>
                <cfset contacts = EntityLoad("ContactsTable")>
                <cfloop array="#contacts#" index="data">
                    <cfset  contactId= data.getUserId()>
                    <cfif session.UserId EQ data.getAdminId()>
                        <div>
                            <tr class="ms-5">
                                <td><img src="./assets/uploads/#data.getPhoto()#" alt="image" width="30" height="30"></td>
                                <td>#data.getFirstName()# #data.getLastName()#</td>
                                <td>#data.getGender()#</td>
                                <td>#data.getDOB()#</td>
                                <td>#data.getAddress()#</td>
                                <td>#data.getStreet()#</td>
                                <td>#data.getPincode()#</td>
                                <td>#data.getEmail()#</td>
                                <td>#data.getPhone()#</td>
                            </tr>
                        </div>
                    </cfif>
                </cfloop>
            </tbody>
        </table>                
    </cfhtmltopdf>
</cfoutput>
