component persistent="true" table="HobbysTable" {
    property name="HobbyId" fieldtype="id" generator="identity";
    property name="Hobbies" cfc="ContactsTable";
}