<cfcomponent>
    <cffunction name="checkUserLogin" access="remote" returntype="query">
        <cfargument  name="strUserName" required="true">
        <cfargument  name="strPassword" required="true">
        <cfquery name="qrycheckLogin" datasource="SQLDb">
            select userName,password from UserTables
            where userName=<cfqueryparam value="#arguments.strUserName#" cfsqltype="cf_sql_varchar">
            AND password=<cfqueryparam value="#arguments.strPassword#" cfsqltype="cf_sql_varchar"> 
        </cfquery>
        <cfreturn qrycheckLogin>
    </cffunction>
</cfcomponent>