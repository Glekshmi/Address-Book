
<cfoutput>
    <cfsavecontent variable="saveContent1">
    <cfcontent type="application/msexcel">
        <table class="w-100">
                            <thead>
                                <tr class="text-primary">
                                    <th></th>
                                    <th class="tableField FieldFontSize">NAME</th>
                                    <th class="tableField FieldFontSize">EMAIL ID</th>
                                    <th class="tableField FieldFontSize">PHONE NUMBER</th>
                                    <th></th>
                                    <th></th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody>
                                <cfset contacts = EntityLoad("ContactsTable")>
                                <cfloop array="#contacts#" index="data">
                                    <cfset  contactId= data.getUserId()>
                                    <cfif session.UserId EQ data.getAdminId()>
                                        <div>
                                            <tr class="ms-5">
                                                <td></td>
                                                <td>#data.getFirstName()# #data.getLastName()#</td>
                                                <td>#data.getEmail()#</td>
                                                <td>#data.getPhone()#</td>
                                                <th><button type="button" class="btn btn-outline-primary viewBtn  m-0 btnEdit" data-id="#contactId#" data-bs-toggle="modal" data-bs-target="##myModal">EDIT</button></th>
                                                <th><button type="button" class="btn btn-outline-primary viewBtn btnDelete m-0" data-id="#contactId#" data-bs-toggle="modal" data-bs-target="##deleteModal">DELETE</button></th>
                                                <th><button type="button" class="btn btn-outline-primary viewBtn btnView m-0" data-id="#contactId#" data-bs-toggle="modal" data-bs-target="##viewModal">VIEW</button></th>
                                            </tr>
                                        </div>
                                    </cfif>
                                </cfloop>
                            </tbody>
			            </table>      
    </cfsavecontent>
<cffile action="write" mode="777" output="#saveContent1#" file="Report.xls">     
</cfoutput>

