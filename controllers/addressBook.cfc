component {
    variables.compObj = createObject("component","models/addressBook");
    remote any function doLogin(strUsername, strPassword) returnFormat="JSON"{
        local.errorMSg='';
        local.qryUserExist ='';
        local.jsonResponse = {};
        if(len(trim(strEmail)) EQ 0 || len(trim(strPassword)) EQ 0)
            local.errorMSg='Required user name and password';
        if(len(local.errorMSg) EQ 0){
            local.encryptedPassword = Hash(strPassword, 'SHA-512');
            local.qryUserExist = variables.compObj.checkUserLogin(strEmail=strEmail,strPassword=strPassword);
            if (local.qryUserExist.recordCount){
                session.userLoggedIn = true;
                session.UserId = local.qryUserExist.UserId;
                session.UserName = local.qryUserExist.FullName;
                session.adminEmail = local.qryUserExist.EmailId;
                local.jsonResponse["success"] = true;
                local.jsonResponse["message"] = "Successfully Logged In";
            }
            else{
                local.jsonResponse["success"] = false;
                local.jsonResponse["message"] = "Invalid userrname or password";
            }
        }
        else{
            local.jsonResponse["success"] = false;
            local.jsonResponse["message"] = "#local.errorMSg#";
        }
        return local.jsonResponse;
    }

    remote any function registerUser() returnFormat="JSON" {
        local.errorsMsg ='';
        local.emailRegex = "^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$";
        local.passwordRegex  = '^[a-zA-Z]+[\W_][0-9]+$';
    
        if (len(strFullName) EQ 0 || len(strEmail) EQ 0 || len(strUsername) EQ 0 || len(strPassword) EQ 0)
            local.errorsMsg &= "All fields are required"&"<br>";
            //writeDump(local.errorsMsg)abort;
        else if (reFind("\d", strFullName))
            local.errorsMsg &= "Full Name should contain alphabets only"&"<br>";
        else if (reFind("\d", strUsername))
            local.errorsMsg &= "Username should contain alphabets only"&"<br>";
        else if (NOT reFind(local.emailRegex, strEmail))
            local.errorsMsg &= "Please enter a valid email id"&"<br>";
        else if (len(strPassword) < 8)
            local.errorsMsg &= "Password should be at least 8 characters long"&"<br>";
        else if (NOT reFind(local.passwordRegex, strPassword))
            local.errorsMsg &= "Password should be a combination of alphabets, digits and special characters"&"<br>";

        local.jsonResponse = {};

        if (len(local.errorsMsg) EQ 0){
            local.registerUser=variables.compObj.registerUser(strFullName = strFullName, strEmail = strEmail, strUsername = strUsername, strPassword = strPassword, strPhoto = strPhoto);
            //writeDump(local.registerUser)abort;
            if(local.registerUser EQ "true") {
                local.jsonResponse["success"] = true;
                local.jsonResponse["message"] = "Successfully completed registration!!!";
            } 
            else {
                local.jsonResponse["success"] = false;
                local.jsonResponse["message"] = "You already have an account!!!";
            }
        }
        else{
            local.jsonResponse["success"] = false;
            local.jsonResponse["message"] = "#local.errorsMsg#";
        }
         return local.jsonResponse;
    }

    public function login() {
        if(session.userLoggedIn)
        cflocation(url="?action=display");
    }
    
    remote any function logout() {
        session.userLoggedIn=false;
        cflocation(url="../?action=login");
    }

    remote any function checkEmailExist(contactId, strEmail) returnFormat="JSON"{
        local.error='';
        if(strEmail==''){
            error+="Fill all the fields";
        }
        if(len(local.error) EQ 0){
            local.checkEmailExist=variables.compObj.checkEmailExist(contactId=contactId,strEmail=strEmail);
            if (local.checkEmailExist) {
                return {"success":true};
            } 
            else {
                return {"success": false,"message":"Email already exist!!!"};
            }
        }
        else{
            return {"success":false,"message":local.error};
        }
           
    }
    remote any function checkExcelFileExist() returnFormat="JSON"{
        local.excelFile = fileExcel;
        local.getExcelFile=variables.compObj.getExcelFile(fileExcel = local.excelFile);
        
        
    }
}