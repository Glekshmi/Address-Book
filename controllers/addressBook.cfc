component {
    local.componentObj = createObject("component","models/addressBook");
    remote string function doLogin(strUsername,strPassword) returnFormat="JSON"{
        local.errorMSg='';
        if(len(trim(strUserName)) EQ 0 || len(trim(strPassword)) EQ 0)
            local.errorMSg='Required user name and password';
        if(len(local.errorMSg) EQ 0){
            /*local.encryptedPassword = Hash(local.strPassword, 'SHA-512');*/
            local.qryUserExist = local.componentObj.checkUserLogin(strUserName=strUserName,strPassword=strPassword);
            if (qryUserExist.recordCount){
                session.userLoggedIn = true;
                local.jsonResponse = {};
                local.jsonResponse["success"] = "true";
                local.jsonResponse["message"] = "Successfully Logged In";
            }
            else{
                local.jsonResponse["success"] = "false";
                local.jsonResponse["message"] = "Invalid userrname or password";
            }
        }
        else{
            local.jsonResponse["success"] = "false";
            local.jsonResponse["message"] = #local.errorMSg#;
        }
        return local.jsonResponse;
    }
}