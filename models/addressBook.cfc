<cfcomponent>
    <cffunction name="checkUserLogin" access="remote" returntype="query">
        <cfargument  name="strEmail" required="true">
        <cfargument  name="strPassword" required="true" default="">
        <cfset local.encryptedPassword = Hash(arguments.strPassword, 'SHA-512')>
        <cfquery name="qrycheckLogin" datasource="coldfusionDb">
            SELECT UserId,FullName,EmailId,Password,Photo FROM RegisterTable
            WHERE EmailId=<cfqueryparam value="#arguments.strEmail#" cfsqltype="cf_sql_varchar">
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
                SELECT Username,Password FROM RegisterTable
                WHERE UserName=<cfqueryparam value="#arguments.strUserName#" cfsqltype="cf_sql_varchar">
                AND Password=<cfqueryparam value="#local.encryptedPassword#" cfsqltype="cf_sql_varchar"> 
            </cfquery>
            <cfif qrycheckLogin.recordCount EQ 0> 
                <cfquery name="qryAddUser" dataSource="coldFusionDb" result="qryResult">
                    INSERT INTO RegisterTable (FullName,EmailId,Username,Password,Photo)
                    VALUES(
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
            SELECT 1 FROM ContactsTable
            WHERE Email=<cfqueryparam value="#arguments.strEmail#" cfsqltype="cf_sql_varchar">
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
            SELECT 1 
            FROM RegisterTable
            WHERE EmailId=<cfqueryparam value="#arguments.strEmail#" cfsqltype="cf_sql_varchar">
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
                    SELECT Photo FROM ContactsTable
                    WHERE UserId=<cfqueryparam value="#arguments.contactId#" cfsqltype="cf_sql_integer">
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
                WHERE UserId=<cfqueryparam value="#arguments.contactId#" cfsqltype="cf_sql_integer">
            </cfquery> 
            <cfset newHobbyIdArr = listToArray(arguments.intHobbies,',')>
            <cfif arrayLen(newHobbyIdArr)>
                <cfquery name="getExistingIds">   
                    SELECT HobbyId
                    FROM ContactHobbyLinkTable
                    WHERE ContactId=<cfqueryparam value="#arguments.contactId#" cfsqltype="cf_sql_integer">
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
                            INSERT INTO ContactHobbyLinkTable(ContactId,HobbyId)
                            VALUES(
                                <cfqueryparam value="#contactId#" cfsqltype="cf_sql_integer">,
                                <cfqueryparam value="#addHobby#" cfsqltype="cf_sql_integer">
                            )
                        </cfquery>
                    </cfloop>
                </cfif>
                <cfif arrayLen(removedHobbies) GT 0>
                    <cfquery name="qryDeleteHobby" result="delRes">
                        DELETE FROM ContactHobbyLinkTable
                        WHERE ContactId = <cfqueryparam value="#arguments.contactId#" cfsqltype="cf_sql_integer">
                        AND HobbyId IN (
                            <cfqueryparam value="#arrayToList(removedHobbies, ',')#" cfsqltype="cf_sql_integer" list="true">
                        )
                    </cfquery>
                </cfif>
            </cfif>
            <cfreturn {"success":true, "message":"Updated successfully"}>
        <cfelse>
            <cfquery name="qrySaveContact" result="resultSaveContact">
                INSERT INTO ContactsTable(Title,FirstName,LastName,Gender,DOB,Photo,Address,Street,Pincode,Email,Phone,AdminId)
                VALUES(
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
                    INSERT INTO ContactHobbyLinkTable(ContactId,HobbyId)
                    VALUES(
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
            DELETE FROM ContactHobbyLinkTable
            WHERE contactId=<cfqueryparam value="#arguments.contactId#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfquery name="qryDeleteContact">
            DELETE FROM ContactsTable
            WHERE UserId=<cfqueryparam value="#arguments.contactId#" cfsqltype="cf_sql_integer">
        </cfquery>
        </cftransaction>
        <cfreturn {"success":"true"}>
    </cffunction>

    <cffunction name="hobbiesDifference" access="public" returntype="array">
    <cfargument name="newHobbyArr" required="true">
    <cfargument name="oldHobbyArr" required="true">
    <cfset local.diffList = []>
    <cfset local.diffList = arrayFilter(newHobbyArr, function(hobby) {
        return not arrayFind(oldHobbyArr, hobby);
    })>
    <cfreturn local.diffList>
    </cffunction>
  
    <cffunction name="uploadExcelFile" access="remote" returnformat="json">
    <cfargument name="fileExcel" required="true" type="string">
    <cfset local.path = ExpandPath("../assets/uploads/")>
    <cffile action="upload" fileField="fileExcel" destination="#local.path#" nameConflict="makeunique">
    <cfset local.excelSheet = cffile.serverFile>
    <cfspreadsheet action="read" src="#local.path##local.excelSheet#" query="spreadsheetData" excludeHeaderRow="true" headerrow="1" sheet="1">
    <cfset local.successIndex = spreadsheetData.recordCount>
    <cfset local.errorIndex = 1>
    <cfif spreadsheetData.recordCount GTE 1>
        <cfset variables.validHeader = ["Title", "FirstName", "LastName", "Gender", "DOB", "Photo", "Address", "Street", "Pincode", "Email", "Phone", "Hobbies"]>
        <cfset local.excelHeader = ListToArray(spreadsheetData.columnList, ",")>
        <cfset local.matchCount = 0>
        <cfset local.checkHeader = arrayFilter(local.excelHeader, function(headerName){
            return arrayFindNoCase(variables.validHeader, headerName)
        })>
        <cfif arrayLen(local.checkHeader) EQ arrayLen(local.excelHeader)>
            <cfset local.Upload_Result = SpreadsheetNew()>
            <cfset local.headers = ["Title", "FirstName", "LastName", "Gender", "DOB", "Photo", "Address", "Street", "Pincode", "Email", "Phone", "Hobbies", "Result"]>
            <cfloop index="i" from="1" to="#ArrayLen(local.headers)#">
                <cfset SpreadsheetSetCellValue(local.Upload_Result, local.headers[i], 1, i)>
            </cfloop>
            <cfset local.rowIndex = 2>
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
                <cfset local.phoneRegex = "^[789]\d{9}$">
                <cfif len(trim(local.title)) EQ 0>
                    <cfset arrayAppend(local.validationErrors, "title missing")>
                <cfelseif len(local.title) GT 10>
                    <cfset arrayAppend(local.validationErrors, "title limit exceeded")>
                <cfelseif reFind("\d", local.title)>
                    <cfset arrayAppend(local.validationErrors, "invalid title")>
                </cfif>
                <cfif len(trim(local.firstName)) EQ 0>
                    <cfset arrayAppend(local.validationErrors, "firstname missing")>
                <cfelseif len(local.firstName) GT 15>
                    <cfset arrayAppend(local.validationErrors, "firstname limit exceeded")>
                <cfelseif reFind("\d", local.firstName)>
                    <cfset arrayAppend(local.validationErrors, "invalid firstName")>    
                </cfif> 
                <cfif len(trim(local.lastName)) EQ 0>
                    <cfset arrayAppend(local.validationErrors, "lastname missing")>
                <cfelseif len(local.lastName) GT 15>
                    <cfset arrayAppend(local.validationErrors, "lastname limit exceeded")>
                <cfelseif reFind("\d", local.lastName)>
                    <cfset arrayAppend(local.validationErrors, "invalid lastName")>      
                </cfif>

                <cfif len(trim(local.gender)) EQ 0>
                    <cfset arrayAppend(local.validationErrors, "gender missing")>
                <cfelse>
                    <cfset local.validGender = ["male", "female", "other"]>           
                    <cfif NOT arrayContains(local.validGender, lcase(local.gender))>
                        <cfset arrayAppend(local.validationErrors, "invalid gender: #local.gender#")>
                    </cfif>
                </cfif>                
                <cfif len(trim(local.dob)) EQ 0>
                    <cfset arrayAppend(local.validationErrors, "dob missing")>
                <cfelseif NOT IsDate(local.dob)>
                    <cfset arrayAppend(local.validationErrors, "invalid dob")>
                </cfif>
                <cfif len(trim(local.photo)) EQ 0>
                    <cfset arrayAppend(local.validationErrors, "photo missing")>
                <cfelse>
                    <cfset local.validExtensions = ["jpg", "jpeg", "png"]>
                    <cfset local.imageExtension = ListLast(local.photo, ".")>
                    <cfif local.imageExtension EQ local.photo>
                        <cfset arrayAppend(local.validationErrors, "image extension is missing")>
                    <cfelseif NOT arrayContains(local.validExtensions, lcase(local.imageExtension))>
                        <cfset arrayAppend(local.validationErrors, "invalid image extension")>
                    </cfif>
                </cfif>
                <cfif len(trim(local.address)) EQ 0>
                    <cfset arrayAppend(local.validationErrors, "address missing")>   
                <cfelseif len(local.address) GT 50>
                    <cfset arrayAppend(local.validationErrors, "address limit exceeded")>
                <cfelseif reFind("\d", local.address)>
                    <cfset arrayAppend(local.validationErrors, "invalid address")>
                </cfif>
                <cfif len(trim(local.street)) EQ 0>
                    <cfset arrayAppend(local.validationErrors, "street missing")>
                <cfelseif len(local.street) GT 20>
                    <cfset arrayAppend(local.validationErrors, "street limit exceeded")>
                <cfelseif reFind("\d", local.street)>
                    <cfset arrayAppend(local.validationErrors, "invalid street")>
                </cfif>
                <cfif len(trim(local.requiredPincode)) EQ 0>
                    <cfset arrayAppend(local.validationErrors, "pincode missing")>
                <cfelseif len(local.requiredPincode) GT 6>
                    <cfset arrayAppend(local.validationErrors, "pincode limit exceeded")>
                <cfelseif len(local.requiredPincode) LT 6>
                    <cfset arrayAppend(local.validationErrors, "invalid pincode")>
                <cfelseif NOT isvalid("integer",local.requiredPincode)>
                    <cfset arrayAppend(local.validationErrors, "pincode should be numeric")>
                </cfif>
                <cfif len(trim(local.email)) EQ 0>  
                    <cfset arrayAppend(local.validationErrors, "email missing")>
                <cfelseif NOT reFindNoCase(local.emailRegex, local.email)>
                    <cfset arrayAppend(local.validationErrors, "invalid email")>    
                </cfif>
                <cfif len(trim(local.phone)) EQ 0>
                    <cfset arrayAppend(local.validationErrors, "phone missing")>
                <cfelseif NOT reFindNoCase(local.phoneRegex, local.requiredPhone)>
                    <cfset arrayAppend(local.validationErrors, "invalid phone")>
                </cfif>
                <cfquery name="getHobbies">
                    SELECT Hobbies
                    FROM HobbysTable;
                </cfquery>
                <cfset variables.validHobbies = valueArray(getHobbies, "Hobbies")>
                <cfset local.hobbiesList = listToArray(local.hobbies)>
                <cfset local.invalidHobbies = arrayFilter(local.hobbiesList, function(hobby) {
                    return NOT arrayFindNoCase(variables.validHobbies, hobby);
                })>
                <cfif arrayLen(local.invalidHobbies) GT 0>
                    <cfset local.invalidHobbyList = arrayToList(local.invalidHobbies)>
                    <cfset arrayAppend(local.validationErrors, "invalid hobby: #local.invalidHobbyList#")>
                </cfif>
                <cfif arrayLen(local.validationErrors) EQ 0>
                    <cfquery name="qryGetEmail">
                        SELECT 1
                        From ContactsTable
                        WHERE Email = <cfqueryparam value="#local.email#" cfsqltype="cf_sql_varchar">
                    </cfquery>
                    <cfif qryGetEmail.recordCount GT 0>  
                        <cfquery name="qryUpdateContact" result="updateResult">  
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
                            output inserted.UserId
                            WHERE Email=<cfqueryparam value="#local.email#" cfsqltype="cf_sql_varchar">
                        </cfquery>
                        <cfset local.getContactId = qryUpdateContact.UserId>
                        <cfif arrayLen(local.hobbiesList)>
                            <cfquery name="getCurrentIds">
                                SELECT HobbyId
                                FROM HobbysTable
                                WHERE Hobbies IN (
                                <cfqueryparam value="#arrayToList(local.hobbiesList, ',')#" cfsqltype="cf_sql_varchar" list="true">
                                )
                            </cfquery>
                            <cfquery name="getExistingIds">
                                SELECT HobbyId
                                FROM ContactHobbyLinkTable
                                WHERE ContactId=<cfqueryparam value="#local.getContactId#" cfsqltype="cf_sql_integer">
                            </cfquery>
                            <cfset local.existingHobbyIdArr ="">
                            <cfset local.currentHobbyIdArr = "">
                            <cfset local.currentHobbyIdArr = valueArray(getCurrentIds,"HobbyId")>
                            <cfset local.existingHobbyIdArr = valueArray(getExistingIds,"HobbyId")>
                            <cfset local.addedHobbies =[]>
                            <cfset local.removedHobbies = []>
                            <cfset local.addedHobbies = hobbiesDifference(local.currentHobbyIdArr, local.existingHobbyIdArr)>
                            <cfset local.removedHobbies = hobbiesDifference(local.existingHobbyIdArr, local.currentHobbyIdArr)>
                            <cfif arrayLen(local.addedHobbies) GT 0>
                                <cfloop array="#local.addedHobbies#" index="addHobby">
                                    <cfquery name="qrySaveHobby" result="resultSaveHobby">
                                        INSERT INTO ContactHobbyLinkTable(ContactId,HobbyId)
                                        VALUES(
                                            <cfqueryparam value="#local.getContactId#" cfsqltype="cf_sql_integer">,
                                            <cfqueryparam value="#addHobby#" cfsqltype="cf_sql_integer">
                                        )
                                    </cfquery>
                                </cfloop> 
                            </cfif>
                            <cfif arrayLen(local.removedHobbies) GT 0>
                                <cfquery name="qryDeleteHobby" result="delRes">
                                    DELETE FROM ContactHobbyLinkTable
                                    WHERE ContactId = <cfqueryparam value="#local.getContactId#" cfsqltype="cf_sql_integer">
                                    AND HobbyId IN (
                                        <cfqueryparam value="#arrayToList(local.removedHobbies, ',')#" cfsqltype="cf_sql_integer" list="true">
                                    )
                                </cfquery>
                            </cfif>
                        </cfif>
                        <cfset local.status = "Updated">
                        <cfset local.signal = true>
                    <cfelse>
                        <cftransaction>
                        <cfquery name="qrySaveContact" result="resultSaveContact">
                        INSERT INTO ContactsTable(Title,FirstName,LastName,Gender,DOB,Photo,Address,Street,Pincode,Email,Phone,AdminId)
                        VALUES(
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
                            <cfloop index="hobbys" from="1" to="#arrayLen(local.hobbiesList)#">
                                <cfquery name="getHobbyIds">
                                    SELECT HobbyId
                                    FROM HobbysTable
                                    WHERE Hobbies IN ( 
                                        <cfqueryparam value="#local.hobbiesList[hobbys]#" cfsqltype="cf_sql_varchar" list="true"> 
                                    )
                                </cfquery>
                                <cfquery name="qrySaveHobby" result="resultHobby">
                                    INSERT INTO ContactHobbyLinkTable(ContactId,HobbyId)
                                    VALUES(
                                        <cfqueryparam value="#local.contactId#" cfsqltype="cf_sql_integer">,
                                        <cfqueryparam value="#getHobbyIds.HobbyId#" cfsqltype="cf_sql_integer">
                                    )
                                </cfquery>
                            </cfloop>
                        </cfif>
                        </cftransaction>
                        <cfset local.status = "Added">
                        <cfset local.signal = true>
                    </cfif>
                <cfelse>
                    <cfset local.status = arrayToList(local.validationErrors,",")>
                    <cfset local.signal = false>
                </cfif>
                <cfset local.excelData = [
                local.title, local.firstName, local.lastName, local.gender, local.dob, local.photo, 
                local.address, local.street, local.requiredPincode, local.email, local.requiredPhone, local.hobbies, local.status, local.signal ]>
                <cfif local.signal>
                    <cfset local.successIndex++>
                    <cfset local.shiftIndex = local.successIndex>
                <cfelse>
                    <cfset local.errorIndex++>
                    <cfset local.shiftIndex = local.errorIndex>
                </cfif>
                 <cfloop index="colIndex" from="1" to="#ArrayLen(local.excelData)-1#">
                    <cfset SpreadsheetSetCellValue(local.Upload_Result, local.excelData[colIndex], local.shiftIndex, colIndex)>
                </cfloop>
                <cfset local.rowIndex++>
            </cfloop>
            <cfset local.startRow = spreadsheetData.recordCount+1>
            <cfif local.startRow LTE local.successIndex>
                <cfset local.noOfRows = local.errorIndex - spreadsheetData.recordCount>
                <cfset SpreadsheetShiftRows(local.Upload_Result, local.startRow, local.successIndex, local.noOfRows)>
            </cfif>
            <cfset local.filePath = ExpandPath("./Upload_Result.xlsx")>
            <cfspreadsheet action="write" filename="#filePath#" name="Upload_Result" overwrite="true">
            <cfset session.downloadFilePath = local.filePath>
            <cfreturn {"success": true, "message": "File uploaded successfully!"}>
        <cfelse>
            <cfreturn {"success": false, "message": "Column names aren't matching!"}>
        </cfif>
    <cfelse>
        <cfreturn {"success": false, "message": "File contain headers only!"}>
    </cfif>
    </cffunction> 

    <cffunction name="getHobbies" access="remote" returnFormat="json">
    <cfquery name="qryGetHobbies">
        SELECT HobbyId, Hobbies
        FROM HobbysTable;
    </cfquery>
    <cfreturn serializeJSON(qryGetHobbies)>
    </cffunction>
</cfcomponent>


