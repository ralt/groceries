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
            itemInputEl.value = '';
            request
                .post('/item/add')
                .type('form')
                .send({ name: name })
                .promise()
                .then(function(id) {
                    self.list.addItem(new ListItem({
                        id: id,
                        name: name,
                        status: 1
                    }));
                });
        });
    }

};
