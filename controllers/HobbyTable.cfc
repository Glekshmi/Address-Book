component persistent="true" table="HobbyTable" {
    property name="contactId" fieldtype="many-to-one" cfc="ContactsTable" fkcolumn="contactId";
    property name="Hobbies" fieldtype="id";
}