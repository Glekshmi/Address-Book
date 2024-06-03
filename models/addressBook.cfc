<cfcomponent>
    <cffunction name="checkUserLogin" access="remote" returntype="query">
        <cfargument  name="strEmail" required="true">
        <cfargument  name="strPassword" required="true" default="">
        <cfset local.encryptedPassword = Hash(arguments.strPassword, 'SHA-512')>
        <cfquery name="qrycheckLogin" datasource="coldfusionDb">
            select UserId,FullName,EmailId,Password,Photo from RegisterTable
            where EmailId=<cfqueryparam value="#arguments.strEmail#" cfsqltype="cf_sql_varchar">
            AND Password=<cfqueryparam value="#local.encryptedPassword#" cfsqltype="cf_sql_varchar"> 
        </cfquery>
        <cfreturn qrycheckLogin>
    </cffunction>

    <cffunction name="registerUser" access="remote" returntype="string">
        <cfargument name="strFullName" required="true" type="string">
        <cfargument name="strEmail" required="true" type="string"> 
        <cfargument name="strUsername" required="true" type="string">
        <cfargument name="strPassword" required="true" type="string">
        <cfargument name="strPhoto" required="true" type="any">
        <cfargument name="intSubId"  type="any" default=0>
        <cfif intSubId EQ 0>
            <cfset local.path = ExpandPath("../assets/uploads/")>
            <cffile action="upload" destination="#local.path#" nameConflict="makeunique">
            <cfset local.photo = cffile.serverFile>
        <cfelse>
            <cfset local.photo=arguments.strPhoto>
        </cfif>
        <cfset local.encryptedPassword = Hash(arguments.strPassword, 'SHA-512')> 
        <cfset local.success = ''>
        <cfif len(arguments.strUsername) NEQ 0 AND  len(arguments.strPassword) NEQ 0>
            <cfquery name="qrycheckLogin" datasource="coldfusionDb">
                select Username,Password from RegisterTable
                where UserName=<cfqueryparam value="#arguments.strUserName#" cfsqltype="cf_sql_varchar">
                AND Password=<cfqueryparam value="#local.encryptedPassword#" cfsqltype="cf_sql_varchar"> 
            </cfquery>
            <cfif qrycheckLogin.recordCount EQ 0> 
                <cfquery name="qryAddUser" dataSource="coldFusionDb" result="qryResult">
                    insert into RegisterTable (FullName,EmailId,Username,Password,Photo)
                    values(
                    <cfqueryparam value="#arguments.strFullName#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.strEmail#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.strUsername#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#local.encryptedPassword#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#local.photo#" cfsqltype="cf_sql_varchar">
                    )
                </cfquery>
                <cfif qryResult.recordCount>
                    <cfset local.success = "true">
                </cfif>
            <cfelse>
                <cfset local.success = "false">
            </cfif>
        </cfif>
        <cfreturn local.success>
    </cffunction>

    <cffunction name="checkEmailExist" access="remote" returntype="boolean">
        <cfargument  name="contactId" required="true" >
        <cfargument  name="strEmail" required="true" type="string">
        <cfquery name="qrycheckEmail">
            select 1 from ContactsTable
            where Email=<cfqueryparam value="#arguments.strEmail#" cfsqltype="cf_sql_varchar">
            AND Email !=<cfqueryparam value="#session.adminEmail#" cfsqltype="cf_sql_varchar">
            AND AdminId = <cfqueryparam value="#session.UserId#" cfsqltype="cf_sql_varchar">
            AND UserId != <cfqueryparam value="#arguments.contactId#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfif qrycheckEmail.recordCount>
            <cfreturn false>
        <cfelse>
            <cfreturn true>
        </cfif>
    </cffunction>

    <cffunction name="checkUserExistInRegister" access="remote" returnFormat="json">
        <cfargument name="strEmail"  required="true" type="string">
        <cfquery name="qryCheckEmail">
            select 1 
            from RegisterTable
            where EmailId=<cfqueryparam value="#arguments.strEmail#" cfsqltype="cf_sql_varchar">
        </cfquery>
        <cfif qryCheckEmail.recordCount>
            <cfreturn {"success":false,"message":"Email Id already present"}>
        <cfelse>
            <cfreturn {"success":true}>
        </cfif>
    </cffunction>

    <cffunction name="saveContact" access="remote" returnFormat="json">
        <cfargument name="contactId" required="true" >
        <cfargument name="strTitle" required="true" type="string">
        <cfargument name="strFirstName" required="true" type="string">
        <cfargument name="strLastName" required="true" type="string">
        <cfargument name="strGender" required="true" type="string">
        <cfargument name="strDOB" required="true" type="any">
        <cfargument name="imageFile" required="true" type="any">
        <cfargument name="strAddress" required="true" type="string">
        <cfargument name="strStreet" required="true" type="string">
        <cfargument name="strPincode" required="true" >
        <cfargument name="strEmail" required="true" type="string">
        <cfargument name="strPhone" required="true" >
        <cfset local.contactDate = dateFormat(arguments.strDOB, "dd-mm-yyyy")>
        <cfset local.success = ''>
        <cfset local.path = ExpandPath("../assets/uploads/")>
        <cffile action="upload" destination="#local.path#" nameConflict="makeunique">
        <cfset local.photo = cffile.serverFile>
        <cfif arguments.contactId GT 0>
            <cfquery name="qryUpdateContact">
                update ContactsTable 
                set Title=<cfqueryparam value="#arguments.strTitle#" cfsqltype="cf_sql_varchar">,
                FirstName=<cfqueryparam value="#arguments.strFirstName#" cfsqltype="cf_sql_varchar">,
                LastName=<cfqueryparam value="#arguments.strLastName#" cfsqltype="cf_sql_varchar">,
                Gender=<cfqueryparam value="#arguments.strGender#" cfsqltype="cf_sql_varchar">,
                DOB=<cfqueryparam value="#arguments.strDOB#" cfsqltype="cf_sql_date">,
                Photo=<cfqueryparam value="#local.photo#" cfsqltype="cf_sql_varchar">,
                Address=<cfqueryparam value="#arguments.strAddress#" cfsqltype="cf_sql_varchar">,
                Street=<cfqueryparam value="#arguments.strStreet#" cfsqltype="cf_sql_varchar">,
                Pincode=<cfqueryparam value="#arguments.strPincode#" cfsqltype="cf_sql_varchar">,
                Email=<cfqueryparam value="#arguments.strEmail#" cfsqltype="cf_sql_varchar">,
                Phone=<cfqueryparam value="#arguments.strPhone#" cfsqltype="cf_sql_varchar">,
                AdminId=<cfqueryparam value="#session.UserId#" cfsqltype="cf_sql_varchar">
                where UserId=<cfqueryparam value="#arguments.contactId#" cfsqltype="cf_sql_integer">
            </cfquery>
            <cfreturn {"success":true, "message":"Updated successfully"}>
        <cfelse>
            <cfquery name="qrySaveContact" result="resultSaveContact">
                insert into ContactsTable(Title,FirstName,LastName,Gender,DOB,Photo,Address,Street,Pincode,Email,Phone,AdminId)
                values(
                    <cfqueryparam value="#arguments.strTitle#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.strFirstName#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.strLastName#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.strGender#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#local.contactDate#" cfsqltype="cf_sql_date">,
                    <cfqueryparam value="#local.photo#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.strAddress#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.strStreet#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.strPincode#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.strEmail#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.strPhone#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#session.UserId#" cfsqltype="cf_sql_integer">
                )
            </cfquery>
            <cftry>
                <cfif resultSaveContact.recordCount>
                    <cfset local.success = true>
                </cfif>
                <cfcatch type="any"> 
                    <cfset local.success = false>
                </cfcatch>
            </cftry>
            <cfreturn {"success":local.success,"message":''}>
        </cfif>
    </cffunction>

    <cffunction name="getContactDetails" access="remote" returnFormat="json">
        <cfargument  name="contactId" required="true">
        <cfquery name="qryGetContactDetails" datasource="coldfusionDb">
            select concat(Title,' ',FirstName,' ',LastName) as Name,Gender,DOB,Photo,concat(Address,' ',Street) as Address,Pincode,Email,Phone from ContactsTable
            where UserId=<cfqueryparam value="#arguments.contactId#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfreturn serializeJSON(qryGetContactDetails)>
    </cffunction>

    <cffunction name="getContact" access="remote" returnFormat="json">
        <cfargument  name="contactId" required="true">
        <cfquery name="qryGetContactDetails" >
            select Title,FirstName,LastName,Gender,DOB,Photo,Address,Street,Pincode,Email,Phone from ContactsTable
            where UserId=<cfqueryparam value="#arguments.contactId#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfreturn {"success":true,"title":qryGetContactDetails.Title,"firstname":qryGetContactDetails.Firstname,"lastname":qryGetContactDetails.LastName,"gender":qryGetContactDetails.Gender,"dob":qryGetContactDetails.DOB,"photo":qryGetContactDetails.Photo,"address":qryGetContactDetails.Address,"street":qryGetContactDetails.Street,"pincode":qryGetContactDetails.Pincode,"email":qryGetContactDetails.Email,"phone":qryGetContactDetails.Phone}>
    </cffunction>

    <cffunction name="deleteContact" access="remote" returnFormat="json">
        <cfargument  name="contactId" required="true">
        <cfquery name="qryDeleteContact" datasource="coldfusionDb" result="delResult">
            delete from ContactsTable
            where UserId=<cfqueryparam value="#arguments.contactId#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfreturn {"success":"true"}>
    </cffunction>

    <cffunction name="checkExcelFileExist" access="remote" returntype="any">
        <cfargument  name="fileExcel" required="true">
        <cfset local.path = ExpandPath("../assets/uploads/")>
        <cffile action="upload" destination="#local.path#" nameConflict="makeunique">
        <cfset local.excelSheet = cffile.serverFile>
        <cfspreadsheet action="read" src="#local.path#/#local.excelSheet#" query="spreadsheetData" headerrow="1" rows='2-10'>
        <cfset columnNames = ListToArray(spreadsheetData.columnList)>
        <cfset predefinedTitles = ["Title", "FirstName", "LastName", "Gender", "DOB", "Photo", "Address", "Street", "Pincode", "Email", "Phone"]>
        <cfloop array="#columnNames#" index="columnName">
            <cfset isTitleMatch = false>
            <cfloop array="#predefinedTitles#" index="title">
                <cfif CompareNoCase(columnName, title) EQ 0>
                    <cfset isTitleMatch = true>
                </cfif>
            </cfloop>
        </cfloop>
        <cfdump  var="#isTitleMatch#" abort>
        <cfloop query="#spreadsheetData#">
            <cfset local.title = spreadsheetData.Title>
            <cfset local.firstName = spreadsheetData.FirstName>
            <cfset local.lastName = spreadsheetData.LastName>
            <cfset local.gender = spreadsheetData.Gender>
            <cfset local.dob = spreadsheetData.DOB>
            <cfset local.photo = spreadsheetData.Photo>
            <cfset local.address = spreadsheetData.Address>
            <cfset local.street = spreadsheetData.Street>
            <cfset local.pincode = spreadsheetData.Pincode>
            <cfset local.email = spreadsheetData.Email>
            <cfset local.phone = spreadsheetData.Phone>
            <cfset local.requiredPincode = replace(local.pincode, ",", "", "all")>
            <cfset local.requiredPhone = replace(local.phone, ",", "", "all")>
            <cfquery name="qryGetEmail" >
                select 1 from ContactsTable
                where Email=<cfqueryparam value="#local.email#" cfsqltype="cf_sql_varchar">
            </cfquery>
            <cfif qryGetEmail.recordCount>
                <cfcontinue>
            <cfelse>
                <cfquery name="qrySaveContact" result="resultSaveContact">
                    insert into ContactsTable(Title,FirstName,LastName,Gender,DOB,Photo,Address,Street,Pincode,Email,Phone,AdminId)
                    values(
                        <cfqueryparam value="#local.title#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#local.firstName#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#local.lastName#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#local.gender#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#local.dob#" cfsqltype="cf_sql_date">,
                        <cfqueryparam value="#local.photo#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#local.address#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#local.street#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#local.requiredPincode#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#local.email#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#local.requiredPhone#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#session.UserId#" cfsqltype="cf_sql_integer">
                    )
                </cfquery>
            </cfif>
       </cfloop>
       <cfif resultSaveContact.recordCount>
            <cfreturn true>
        <cfelse>
            <cfreturn false>
       </cfif>
    </cffunction>    
</cfcomponent>
