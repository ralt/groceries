import ListItem from "./list-item";
import request from "superagent-bluebird-promise";

let $ = x => document.querySelector(x);
let listEl = $('#list');
let boughtEl = $('#bought');

export default class List {

    constructor() {
        this.items = [];
    }

    fetchItems() {
        return request
            .get('/item/list')
            .promise()
            .get('body');
    }

    addItems(items) {
        items.forEach(item => this.addItem(new ListItem(item)));
    }

    addItem(item) {
        this.items.push(item);
        switch (item.getStatus()) {
        case 1:
            listEl.appendChild(item.getElement());
            break;
        case 2:
            boughtEl.appendChild(item.getElement());
            break;
        }

    }

    clear() {
        this.items.forEach(item => item.getElement().remove());
        request
            .post('/list/clear')
            .end();
    }

};
