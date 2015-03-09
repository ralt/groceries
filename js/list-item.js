import request from "superagent-bluebird-promise";

let $ = x => document.querySelector(x);
let boughtEl = $('#bought');

export default class ListItem {

    constructor(item) {
        this.id = item.id;
        this.name = item.name;
        this.status = item.status;
        this.el = document.createElement('div');
        this.el.textContent = item.name;
        this.el.addEventListener('click', this.changeStatus.bind(this));
    }

    changeStatus(e) {
        switch (this.status) {
        case 1:
            this.setBought();
            break;
        case 2:
            this.setDeleted();
        }
    }

    setBought() {
        this.status = 2;
        boughtEl.appendChild(this.el);
        request
            .post('/item/status')
            .type('form')
            .send({ id: this.id, status: 2 })
            .end();
    }

    setDeleted() {
        let reallyDelete = confirm('Really delete?');
        if (!reallyDelete) return;
        this.el.remove();
        request
            .post('/item/status')
            .type('form')
            .send({ id: this.id, status: 3 })
            .end();
    }

    getElement() {
        return this.el;
    }

    getStatus() {
        return this.status;
    }

};
