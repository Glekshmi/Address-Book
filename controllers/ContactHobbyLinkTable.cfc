component persistent="true" table="ContactHobbyLinkTable" {
    property name="LinkId";
    property name="contactId" fieldtype="many-to-one" cfc="ContactsTable" fkcolumn="contactId";
    property name="HobbyId" fieldtype="id";
    
}