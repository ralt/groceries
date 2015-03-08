import request from "superagent-bluebird-promise";

let $ = x => document.querySelector(x);
let $$ = x => document.querySelectorAll(x);

let itemsList = $('#items');
let itemInput = itemsList.elements.items;

getItems().then(autocomplete);

$('#add').addEventListener('submit', e => {
    e.preventDefault();
    request
        .post('/item/add')
        .send({ name: itemInput.value });
});

function getItems() {
    return request
        .get('/item')
        .promise()
        .get('body');
}

function autocomplete(items) {
    items.forEach(x => {
        let el = document.createElement('option');
        el.value = x;
        itemsList.appendChild(el);
    });
}
