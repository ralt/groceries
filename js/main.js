import AddForm from "./add-form";
import List from "./list";
import Clear from "./clear";

let list = new List();
let addForm = new AddForm(list);
let clear = new Clear(list);

addForm.fetchItems().then(addForm.addAutocompleteItems.bind(addForm));
addForm.setupListeners();

list.fetchItems().then(list.addItems.bind(list));

clear.setupListeners();
