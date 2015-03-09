import request from "superagent-bluebird-promise";

let $ = x => document.querySelector(x);
let boughtEl = $('#bought');

export default class ListItem {

    constructor(item) {
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
        boughtEl.appendChild(this.el);
        request
            .post('/item/status')
            .type('form')
            .send({ name: this.el.textContent, status: 2 })
            .end();
    }

    setDeleted() {
        let reallyDelete = confirm('Really delete?');
        if (!reallyDelete) return;
        this.el.remove();
        request
            .post('/item/status')
            .type('form')
            .send({ name: this.el.textContent, status: 3 })
            .end();
    }

    getElement() {
        return this.el;
    }

    getStatus() {
        return this.status;
    }

};
