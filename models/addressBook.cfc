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
        <cfargument name="imageFile" type="any" >
        <cfargument name="strAddress" required="true" type="string">
        <cfargument name="strStreet" required="true" type="string">
        <cfargument name="strPincode" required="true">
        <cfargument name="strEmail" required="true" type="string">
        <cfargument name="strPhone" required="true" >
        <cfargument name="intHobbies" required="true">
        <cfset local.contactDate = dateFormat(arguments.strDOB, "dd-mm-yyyy")>
        <cfset local.success = ''>
        <cfset local.hobbyList = listToArray(arguments.intHobbies,",")>
        <cfset local.photo = "">
        <cfif  len(arguments.imageFile) GT 9>
            <cfset local.path = ExpandPath("../assets/uploads/")>
            <cffile action="upload" fileField="imageFile" destination="#local.path#" nameConflict="makeunique">
            <cfset local.photo = cffile.serverFile>
        <cfelse>
            <cfif contactId GT 0>
                <cfquery name="qryGetPhoto">
                    select Photo from ContactsTable
                    where UserId=<cfqueryparam value="#arguments.contactId#" cfsqltype="cf_sql_integer">
                </cfquery>
                <cfset local.photo = qryGetPhoto.Photo> 
            </cfif>
        </cfif>
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
            <cfset newHobbyIdArr = listToArray(arguments.intHobbies,',')>
            <cfif arrayLen(newHobbyIdArr)>
                <cfquery name="getExistingIds">
                    Select HobbyId
                    From ContactHobbyLinkTable
                    Where ContactId=<cfqueryparam value="#arguments.contactId#" cfsqltype="cf_sql_integer">
                </cfquery>
                <cfset existingHobbyIds ="">
                <cfset existingHobbyIds = ValueList(getExistingIds.HobbyId)>
                <cfset existingHobbyIdArr = listToArray(existingHobbyIds)>
                <cfset addedHobbies =[]>
                <cfset removedHobbies = []>
                <cfset addedHobbies = hobbiesDifference(newHobbyIdArr, existingHobbyIdArr)>
                <cfset removedHobbies = hobbiesDifference(existingHobbyIdArr, newHobbyIdArr)>
                <cfif arrayLen(addedHobbies) GT 0>
                    <cfloop array="#addedHobbies#" index="addHobby">
                        <cfquery name="qrySaveHobby" result="resultSaveHobby">
                            Insert Into ContactHobbyLinkTable(ContactId,HobbyId)
                            Values(
                                <cfqueryparam value="#contactId#" cfsqltype="cf_sql_integer">,
                                <cfqueryparam value="#addHobby#" cfsqltype="cf_sql_integer">
                            )
                        </cfquery>
                    </cfloop>
                </cfif>
                <cfif arrayLen(removedHobbies) GT 0>
                    <cfquery name="qryDeleteHobby" result="delRes">
                        Delete from ContactHobbyLinkTable
                        where ContactId = <cfqueryparam value="#arguments.contactId#" cfsqltype="cf_sql_integer">
                        And HobbyId In (
                            <cfqueryparam value="#arrayToList(removedHobbies, ',')#" cfsqltype="cf_sql_integer" list="true">
                        )
                    </cfquery>
                </cfif>
            </cfif>
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
            <cfset local.contactId = resultSaveContact.generatedKey>
            <cfloop array="#hobbyList#" index="hobby">
                <cfquery name="qrySaveHobby" result="resultSaveHobby">
                    insert into ContactHobbyLinkTable(ContactId,HobbyId)
                    values(
                        <cfqueryparam value="#local.contactId#" cfsqltype="cf_sql_integer">,
                        <cfqueryparam value="#hobby#" cfsqltype="cf_sql_varchar">
                    )
                </cfquery>
             </cfloop>
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

    <cffunction name="hobbiesDifference" access="public" returntype="array">
    <cfargument name="newList" required="true">
    <cfargument name="oldList" required="true">
    <cfset var diff = []>
    <cfloop array="#newList#" index="id">
        <cfif not ArrayContains(oldList, id)>
            <cfset arrayAppend(diff, id)>
        </cfif>
    </cfloop>
    <cfreturn diff>
    </cffunction>

    <cffunction name="getContact" access="remote" returnFormat="json">
        <cfargument  name="contactId" required="true">
        <cfquery name="qryGetContact">
            SELECT ct.Title, ct.FirstName, ct.LastName, ct.Gender, ct.DOB, ct.Photo,
                   ct.Address, ct.Street, ct.Pincode, ct.Email, ct.Phone, STRING_AGG(ht.Hobbies, ', ') AS Hobbies,  
                    STRING_AGG(ht.HobbyId, ', ') AS HobbyIds 
            FROM ContactsTable ct
            LEFT JOIN ContactHobbyLinkTable cht ON ct.UserId = cht.ContactId
            LEFT JOIN HobbysTable ht ON cht.HobbyId = ht.HobbyId
            WHERE ct.UserId = <cfqueryparam value="#arguments.contactId#" cfsqltype="cf_sql_integer">  
            GROUP BY ct.Title, ct.FirstName, ct.LastName, ct.Gender, ct.DOB,  ct.Photo,  
                     ct.Address,  ct.Street, ct.Pincode, ct.Email,ct.Phone;
        </cfquery>
        <cfreturn qryGetContact>
    </cffunction>

    <cffunction name="deleteContact" access="remote" returnFormat="json">
        <cfargument  name="contactId" required="true">
        <cftransaction>
            <cfquery name="qryDeleteHobby">
            delete from ContactHobbyLinkTable
            where contactId=<cfqueryparam value="#arguments.contactId#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfquery name="qryDeleteContact">
            delete from ContactsTable
            where UserId=<cfqueryparam value="#arguments.contactId#" cfsqltype="cf_sql_integer">
        </cfquery>
        </cftransaction>
        <cfreturn {"success":"true"}>
    </cffunction>

    <cffunction name="checkExcelFileExist" access="remote" returnformat="json">
    <cfargument name="fileExcel" required="true" type="string">
    <cfset local.path = ExpandPath("../assets/uploads/")>
    <cffile action="upload" fileField="fileExcel" destination="#local.path#" nameConflict="makeunique">
    <cfset local.excelSheet = cffile.serverFile>
    <cfspreadsheet action="read" src="#local.path##local.excelSheet#" query="spreadsheetData" headerrow="1" rows="2-10">

    <cfif spreadsheetData.recordCount GTE 1>
        <cfquery name="getColumnName">
            SELECT COLUMN_NAME
            FROM INFORMATION_SCHEMA.COLUMNS
            WHERE TABLE_NAME = 'ContactsTable'
            AND TABLE_SCHEMA = 'dbo'
        </cfquery>

        <cfquery name="getHobbyColName" >
            SELECT COLUMN_NAME
            FROM INFORMATION_SCHEMA.COLUMNS
            WHERE TABLE_NAME = 'HobbysTable'
            AND TABLE_SCHEMA = 'dbo'
            AND COLUMN_NAME = 'Hobbies'
        </cfquery>

        <cfset ColNames = []>
        <cfloop query="getColumnName">
            <cfset arrayAppend(ColNames, getColumnName.COLUMN_NAME)>
        </cfloop>

        <cfloop query="getHobbyColName">
            <cfset arrayAppend(ColNames, getHobbyColName.COLUMN_NAME)>
        </cfloop>

        <cfset excelColNames = ListToArray(spreadsheetData.columnList, ",")>

        <cfset matchCount = 0>
        <cfloop array="#excelColNames#" index="headerName">
            <cfif arrayFindNoCase(ColNames, headerName)>
                <cfset matchCount = matchCount + 1>
            </cfif>
        </cfloop>

        <cfif matchCount EQ arrayLen(excelColNames)>
            <cfset Upload_Result = SpreadsheetNew()>
            <cfset headers = ["Title", "FirstName", "LastName", "Gender", "DOB", "Photo", "Address", "Street", "Pincode", "Email", "Phone", "Hobbies", "Result"]>
            <cfloop index="i" from="1" to="#ArrayLen(headers)#">
                <cfset SpreadsheetSetCellValue(Upload_Result, headers[i], 1, i)>
            </cfloop>
          <!---  <cfdump var="#SpreadsheetInfo(Upload_Result)#">
            <cfloop index="j" from="1" to="#ArrayLen(headers)#">
                <cfset SpreadsheetSetCellValue(Upload_Result, 'abc', 2, j)>
            </cfloop>
            
                <cfdump var="#SpreadsheetGetCellValue(Upload_Result,2,1)#">
            
            <cfabort>--->
            <cfset rowIndex = 2>
            <cfloop query="spreadsheetData">
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
                <cfset local.hobbies = spreadsheetData.Hobbies>
                <cfset local.requiredPincode = replace(local.pincode, ",", "", "all")>
                <cfset local.requiredPhone = replace(local.phone, ",", "", "all")>
                
                <cfset local.validationErrors = []>
                <cfset local.emailRegex = "^[a-zA-Z0-9._%+-]+(?:\+1)?@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$">

                <cfset local.phoneRegex = "^(\+91[\-\s]?)?[0]?(91)?[789]\d{9}$">
                <cfif len(trim(local.title)) EQ 0>
                    <cfset arrayAppend(local.validationErrors, "title missing")>
                </cfif>
            
                <cfif len(trim(local.firstName)) EQ 0>
                    <cfset arrayAppend(local.validationErrors, "firstname missing")>
                <cfelseif len(local.firstName) GT 15>
                    <cfset arrayAppend(local.validationErrors, "firstname limit exceeded")>
                </cfif>
                
                <cfif len(trim(local.lastName)) EQ 0>
                    <cfset arrayAppend(local.validationErrors, "lastname missing")>
                <cfelseif len(local.lastName) GT 15>
                    <cfset arrayAppend(local.validationErrors, "lastname limit exceeded")>
                </cfif>
                
                <cfif len(trim(local.gender)) EQ 0>
                    <cfset arrayAppend(local.validationErrors, "gender missing")>
                </cfif>

                <cfif len(trim(local.dob)) EQ 0>
                    <cfset arrayAppend(local.validationErrors, "dob missing")>
                <cfelseif isValid("integer", local.dob)>
                    <cfset arrayAppend(local.validationErrors, "invalid dob")>
                </cfif>

                <cfif len(trim(local.photo)) EQ 0>
                    <cfset arrayAppend(local.validationErrors, "photo missing")>
                </cfif>

                <cfif len(trim(local.address)) EQ 0>
                    <cfset arrayAppend(local.validationErrors, "address missing")>
                </cfif>

                <cfif len(trim(local.street)) EQ 0>
                    <cfset arrayAppend(local.validationErrors, "street missing")>
                </cfif>

                <cfif len(trim(local.requiredPincode)) EQ 0>
                    <cfset arrayAppend(local.validationErrors, "pincode missing")>
                <cfelseif len(local.requiredPincode) GT 6>
                    <cfset arrayAppend(local.validationErrors, "pincode limit exceeded")>
                </cfif>

                <cfif len(trim(local.email)) EQ 0>  
                    <cfset arrayAppend(local.validationErrors, "email missing")>
                <cfelseif NOT reFindNoCase(local.emailRegex, local.email)>
                    <cfset arrayAppend(local.validationErrors, "Invalid email")>    
                </cfif>
            
                <cfif len(trim(local.phone)) EQ 0>
                    <cfset arrayAppend(local.validationErrors, "phone missing")>
                <cfelseif NOT reFindNoCase(local.phoneRegex, local.requiredPhone)>
                    <cfset arrayAppend(local.validationErrors, "invalid phone")>
                </cfif>
            
                <cfset validHobbies = ["Reading", "Drawing", "Writing", "Cooking", "Singing", "Dancing", "Cycling", "Gardening", "BottleArt", "Swimming"]>
                <cfset local.hobbiesList = listToArray(local.hobbies)>
                <cfloop array="#local.hobbiesList#" index="hobby">
                    <cfif not arrayFindNoCase(validHobbies, trim(hobby))>
                        <cfset arrayAppend(local.validationErrors, "invalid hobby: #hobby#")>
                    </cfif>
                </cfloop>
                
                <cfif arrayLen(local.validationErrors) EQ 0>
                    <cfquery name="qryGetEmail">
                        Select 1
                        From ContactsTable
                        Where Email = <cfqueryparam value="#local.email#" cfsqltype="cf_sql_varchar">
                    </cfquery>
                    
                    <cfif qryGetEmail.recordCount>
                        <cfquery name="qryUpdateContact">
                            update ContactsTable 
                            set Title=<cfqueryparam value="#local.title#" cfsqltype="cf_sql_varchar">,
                            FirstName=<cfqueryparam value="#local.firstName#" cfsqltype="cf_sql_varchar">,
                            LastName=<cfqueryparam value="#local.lastName#" cfsqltype="cf_sql_varchar">,
                            Gender=<cfqueryparam value="#local.gender#" cfsqltype="cf_sql_varchar">,
                            DOB=<cfqueryparam value="#local.dob#" cfsqltype="cf_sql_date">,
                            Photo=<cfqueryparam value="#local.photo#" cfsqltype="cf_sql_varchar">,
                            Address=<cfqueryparam value="#local.address#" cfsqltype="cf_sql_varchar">,
                            Street=<cfqueryparam value="#local.street#" cfsqltype="cf_sql_varchar">,
                            Pincode=<cfqueryparam value="#local.requiredPincode#" cfsqltype="cf_sql_varchar">,
                            Email=<cfqueryparam value="#local.email#" cfsqltype="cf_sql_varchar">,
                            Phone=<cfqueryparam value="#local.requiredPhone#" cfsqltype="cf_sql_varchar">,
                            AdminId=<cfqueryparam value="#session.UserId#" cfsqltype="cf_sql_varchar">
                            where Email=<cfqueryparam value="#local.email#" cfsqltype="cf_sql_varchar">
                        </cfquery>
                        <cfquery name="getExistingIds">
                            Select UserId
                            From ContactsTable
                            Where Email=<cfqueryparam value="#local.email#" cfsqltype="cf_sql_varchar">
                        </cfquery>
                        <cfset local.getContactId = getExistingIds.UserId>
                        
                        <cfif arrayLen(local.hobbiesList)>
                            <cfquery name="getCurrentIds">
                                Select HobbyId
                                From HobbysTable
                                Where Hobbies In (
                                <cfqueryparam value="#arrayToList(local.hobbiesList, ',')#" cfsqltype="cf_sql_varchar" list="true">
                                )
                            </cfquery>
                            
                            <cfquery name="getExistingIds">
                                Select HobbyId
                                From ContactHobbyLinkTable
                                Where ContactId=<cfqueryparam value="#local.getContactId#" cfsqltype="cf_sql_integer">
                            </cfquery>
                            <cfset existingHobbyIdArr ="">
                            <cfset currentHobbyIdArr = "">
                            <cfset currentHobbyIdArr = listToArray(ValueList(getCurrentIds.HobbyId))>
                            <cfset existingHobbyIdArr = listToArray(ValueList(getExistingIds.HobbyId))>
                            <cfset addedHobbies =[]>
                            <cfset removedHobbies = []>
                            <cfset addedHobbies = hobbiesDifference(currentHobbyIdArr, existingHobbyIdArr)>
                            <cfset removedHobbies = hobbiesDifference(existingHobbyIdArr, currentHobbyIdArr)>
                            <cfif arrayLen(addedHobbies) GT 0>
                                <cfloop array="#addedHobbies#" index="addHobby">
                                    <cfquery name="qrySaveHobby" result="resultSaveHobby">
                                        Insert Into ContactHobbyLinkTable(ContactId,HobbyId)
                                        Values(
                                            <cfqueryparam value="#local.getContactId#" cfsqltype="cf_sql_integer">,
                                            <cfqueryparam value="#addHobby#" cfsqltype="cf_sql_integer">
                                        )
                                    </cfquery>
                                </cfloop>
                            </cfif>
                            <cfif arrayLen(removedHobbies) GT 0>
                                <cfquery name="qryDeleteHobby" result="delRes">
                                    Delete from ContactHobbyLinkTable
                                    where ContactId = <cfqueryparam value="#local.getContactId#" cfsqltype="cf_sql_integer">
                                    And HobbyId In (
                                        <cfqueryparam value="#arrayToList(removedHobbies, ',')#" cfsqltype="cf_sql_integer" list="true">
                                    )
                                </cfquery>
                            </cfif>
                        </cfif>
                        <cfset local.status = "Updated">
                    <cfelse>
                            <cfquery name="qrySaveContact" result="resultSaveContact">
                            insert into ContactsTable(Title,FirstName,LastName,Gender,DOB,Photo,Address,Street,Pincode,Email,Phone,AdminId)
                            values(
                                <cfqueryparam value="#local.title#" cfsqltype="cf_sql_varchar">,
                                <cfqueryparam value="#local.firstName#" cfsqltype="cf_sql_varchar">,
                                <cfqueryparam value="#local.lastName#" cfsqltype="cf_sql_varchar">,
                                <cfqueryparam value="#local.gender#" cfsqltype="cf_sql_varchar">,
                                <cfqueryparam value="#local.dob#" cfsqltype="cf_sql_varchar">,
                                <cfqueryparam value="#local.photo#" cfsqltype="cf_sql_varchar">,
                                <cfqueryparam value="#local.address#" cfsqltype="cf_sql_varchar">,
                                <cfqueryparam value="#local.street#" cfsqltype="cf_sql_varchar">,
                                <cfqueryparam value="#local.requiredPincode#" cfsqltype="cf_sql_varchar">,
                                <cfqueryparam value="#local.email#" cfsqltype="cf_sql_varchar">,
                                <cfqueryparam value="#local.requiredPhone#" cfsqltype="cf_sql_varchar">,
                                <cfqueryparam value="#session.UserId#" cfsqltype="cf_sql_integer">
                            )
                            </cfquery>
                            <cfset local.contactId = resultSaveContact.generatedKey> 
                            <cfif arrayLen(local.hobbiesList) GT 0>
                                 <cfset local.hobbyId = []>
                                <cfloop array="#local.hobbiesList#" index="hobbys">
                                    <cfquery name="getHobbyIds" result="resultId">
                                        select HobbyId
                                        FROM HobbysTable
                                        WHERE Hobbies IN ( 
                                            <cfqueryparam value="#hobbys#" cfsqltype="cf_sql_varchar" list="true"> 
                                        )
                                    </cfquery>
                                    <cfset arrayAppend(local.HobbyId, getHobbyIds.HobbyId)>
                                </cfloop>
                                
                                <cfloop array="#local.HobbyId#" index="hobbiesId">
                                    <cfquery name="qrySaveHobby" result="resultHobby">
                                        insert into ContactHobbyLinkTable(ContactId,HobbyId)
                                        values(
                                            <cfqueryparam value="#local.contactId#" cfsqltype="cf_sql_integer">,
                                            <cfqueryparam value="#hobbiesId#" cfsqltype="cf_sql_integer">
                                        )
                                    </cfquery>
                                </cfloop>
                            </cfif>
                        </cfif>
                        <cfset local.status = "Added">
                <cfelse>
                    <cfset local.status = arrayToList(local.validationErrors, '<br>')>
                </cfif>
                <cfset excelData = [
                    local.title, local.firstName, local.lastName, local.gender, local.dob, local.photo, 
                    local.address, local.street, local.requiredPincode, local.email, local.requiredPhone, local.hobbies, local.status ]>
                    <cfloop index="colIndex" from="1" to="#ArrayLen(excelData)#">
                        <cfset SpreadsheetSetCellValue(Upload_Result, excelData[colIndex], rowIndex, colIndex)>
                    </cfloop>
             <cfset rowIndex = rowIndex + 1>
            </cfloop>
    
            <cfset filePath = ExpandPath("./Upload_Result.xlsx")>
            <cfspreadsheet action="write" filename="#session.downloadFilePath#" name="Upload_Result" overwrite="true">
            <cfset session.downloadFilePath = filePath>
            <cfreturn {"success": true, "message": "File uploaded successfully!"}>
        <cfelse>
            <cfreturn {"success": false, "message": "Column names arent matching!"}>
        </cfif> 
    <cfelse>
        <cfreturn {"success": false, "message": "File contains headers only!"}>
    </cfif>
    </cffunction>


    <cffunction name="getHobbies" access="remote" returnFormat="json">
        <cfquery name="qryGetHobbies">
            select HobbyId, Hobbies
            from HobbysTable;
        </cfquery>
        <cfreturn serializeJSON(qryGetHobbies)>
    </cffunction>
</cfcomponent>
