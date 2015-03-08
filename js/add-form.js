import request from "superagent-bluebird-promise";
import ListItem from "./list-item";

let $ = x => document.querySelector(x);
let itemsEl = $('#items');
let addEl = $('#add');
let itemInputEl = addEl.elements.items;

export default class AddForm {

    constructor(list) {
        this.list = list;
    }

    fetchItems() {
        return request
            .get('/item')
            .promise()
            .get('body');
    }

    addAutocompleteItems(items) {
        items.forEach(x => {
            let el = document.createElement('option');
            el.value = x;
            itemsEl.appendChild(el);
        });
    }

    setupListeners() {
        var self = this;
        addEl.addEventListener('submit', e => {
            e.preventDefault();
            let name = itemInputEl.value;
            request
                .post('/item/add')
                .send({ name: name });
            self.list.addItem(new ListItem(name));
        });
    }

};
