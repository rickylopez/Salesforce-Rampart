@isTest
private class OppNoteTest {
	
	@isTest static void createNote() {
	
		Opportunity myOpp  = new Opportunity();
		myOpp.Name         = 'New Deal';
		myOpp.StageName    = 'Prospecting';
		myOpp.CloseDate    = Date.today();
		insert myOpp;

		Note myNote  = new Note();
		myNote.Title = 'Testing from Apex Test Class';
		myNote.Body  = 'Testing the new trigger';
		myNote.ParentID = myOpp.Id;
		insert myNote;

		myNote.Body = 'Update the record';
		update myNote;




	}
	

}