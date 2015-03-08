import ListItem from "./list-item";
import request from "superagent-bluebird-promise";

let $ = x => document.querySelector(x);
let listEl = $('#list');

export default class List {

    fetchItems() {
        return request
            .get('/item/list')
            .promise();
    }

    addItems(items) {
        items.forEach(item => addItem(new ListItems(item)));
    }

    addItem(item) {
        listEl.appendChild(item);
    }

    clear() {
    }

};
