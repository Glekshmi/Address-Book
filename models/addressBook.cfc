<cfcomponent>
    <cffunction name="checkUserLogin" access="remote" returntype="query">
        <cfargument  name="strUserName" required="true">
        <cfargument  name="strPassword" required="true">
        <cfset local.encryptedPassword = Hash(arguments.strPassword, 'SHA-512')>
        <cfquery name="qrycheckLogin" datasource="coldfusionDb">
            select UserId,FullName,Username,Password from RegisterTable
            where UserName=<cfqueryparam value="#arguments.strUserName#" cfsqltype="cf_sql_varchar">
            AND Password=<cfqueryparam value="#local.encryptedPassword#" cfsqltype="cf_sql_varchar"> 
        </cfquery>
        <cfreturn qrycheckLogin>
    </cffunction>
    <cffunction name="registerUser" access="remote" returntype="string">
        <cfargument name="strFullName" required="true" type="string">
        <cfargument name="strEmail" required="true" type="string"> 
        <cfargument name="strUsername" required="true" type="string">
        <cfargument name="strPassword" required="true" type="string">
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
                    insert into RegisterTable (FullName,EmailId,Username,Password)
                    values(
                    <cfqueryparam value="#arguments.strFullName#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.strEmail#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.strUsername#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#local.encryptedPassword#" cfsqltype="cf_sql_varchar">
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
        <cfargument  name="contactId" required="true">
        <cfargument  name="strEmail" required="true" >
      <cfdump  var="#arguments#" abort>
        <cfquery name="qrycheckEmail">
            select 1 from ContactsTable
            where Email=<cfqueryparam value="#arguments.strEmail#" cfsqltype="cf_sql_varchar">
            AND UserId != <cfqueryparam value="#arguments.contactId#" cfsqltype="cf_sql_integer">
        </cfquery>
<!---         <cfdump  var="#qrycheckEmail.recordCount#" abort> --->
        <cfif qrycheckEmail.recordCount>
            <cfreturn true>
        <cfelse>
            <cfreturn false>
        </cfif>
    </cffunction>

    <cffunction name="saveContactDetails" access="remote" returntype="string">
        <cfargument name="contactId" required="true" type="string">
        <cfargument name="strTitle" required="true" type="string">
        <cfargument name="strFirstName" required="true" type="string">
        <cfargument name="strLastName" required="true" type="string">
        <cfargument name="strGender" required="true" type="string">
        <cfargument name="StrDOB" required="true" type="any">
        <cfargument name="strAddress" required="true" type="string">
        <cfargument name="strStreet" required="true" type="string">
        <cfargument name="strEmail" required="true" type="string">
        <cfargument name="StrPhone" required="true" type="numeric">
        <cfset local.success = ''>
        <cfdump  var="#contactId#" abort>
        <cfif arguments.contactId GT 0>
            <cfquery name="qryUpdateContact" result="resultUpdateContact"> 
                update ContactsTable set Title=<cfqueryparam value="#arguments.strTitle#" cfsqltype="cf_sql_varchar">,
                FirstName=<cfqueryparam value="#arguments.strFirstName#" cfsqltype="cf_sql_varchar">,
                LastName=<cfqueryparam value="#arguments.strLastName#" cfsqltype="cf_sql_varchar">,
                Gender=<cfqueryparam value="#arguments.strGender#" cfsqltype="cf_sql_varchar">,
                DOB=<cfqueryparam value="#arguments.StrDOB#" cfsqltype="cf_sql_varchar">,
                Address=<cfqueryparam value="#arguments.strAddress#" cfsqltype="cf_sql_varchar">,
                Street=<cfqueryparam value="#arguments.strStreet#" cfsqltype="cf_sql_varchar">,
                Email=<cfqueryparam value="#arguments.strEmail#" cfsqltype="cf_sql_varchar">,
                Phone=<cfqueryparam value="#arguments.StrPhone#" cfsqltype="cf_sql_varchar">,
                where UserId=<cfqueryparam value="#arguments.contactId#" cfsqltype="cf_sql_integer">
            </cfquery>
            <cfset local.success = 'true'>
        <cfelse>
            <cftry>
            <cfquery name="qrySaveContact" result="qryResult" dataSource="coldFusionDb">
                insert into ContactsTable(Title,FirstName,LastName,Gender,DOB,Address,Street,Email,Phone,AdminId)
                values(
                    <cfqueryparam value="#arguments.strTitle#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.strFirstName#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.strLastName#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.strGender#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.StrDOB#" cfsqltype="cf_sql_date">,
                    <cfqueryparam value="#arguments.strAddress#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.strStreet#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.strEmail#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.StrPhone#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#session.UserId#" cfsqltype="cf_sql_varchar">
                )
            </cfquery>        
            <cfif qryResult.recordCount>
                <cfset local.success = "true">
            </cfif>
            <cfcatch type="any"> 
                <cfset local.success = "false">
            </cfcatch>
        </cftry>
        <cfreturn local.success>
    </cfif>
    </cffunction>

    <cffunction name="getContactDetails" access="remote" returnFormat="json">
        <cfargument  name="contactId" required="true">
        <cfquery name="qryGetContactDetails" datasource="coldfusionDb">
            select concat(Title,' ',FirstName,' ',LastName) as Name,Gender,DOB,concat(Address,' ',Street) as Address,Email,Phone from ContactsTable
            where UserId=<cfqueryparam value="#arguments.contactId#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfreturn serializeJSON(qryGetContactDetails)>
    </cffunction>
    <cffunction name="getContact" access="remote" returnFormat="json">
        <cfargument  name="contactId" required="true">
        <cfquery name="qryGetContactDetails" datasource="coldfusionDb">
            select Title,FirstName,LastName,Gender,DOB,Address,Street,Email,Phone from ContactsTable
            where UserId=<cfqueryparam value="#arguments.contactId#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfreturn {"success":true,"title":qryGetContactDetails.Title,"firstname":qryGetContactDetails.Firstname,"lastname":qryGetContactDetails.LastName,"gender":qryGetContactDetails.Gender,"dob":qryGetContactDetails.DOB,"address":qryGetContactDetails.Address,"street":qryGetContactDetails.Street,"email":qryGetContactDetails.Email,"phone":qryGetContactDetails.Phone}>
    </cffunction>

    

    <cffunction name="deleteContact" access="remote" returnFormat="json">
        <cfargument  name="contactId" required="true">
        <cfquery name="qryDeleteContact" datasource="coldfusionDb">
            delete from ContactsTable
            where UserId=<cfqueryparam value="#arguments.contactId#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfreturn {"success":true}>
    </cffunction>

</cfcomponent>
