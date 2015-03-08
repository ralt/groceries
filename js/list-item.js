import request from "superagent-bluebird-promise";

let $ = x => document.querySelector(x);
let boughtEl = $('#bought');

export default class ListItem {

    constructor(item) {
        this.status = item.status;
        let el = document.createElement('div');
        el.textContent = item.name;
        el.addEventListener('click', self.changeStatus.bind(self));
    }

    changeStatus(e) {
        let target = e.currentTarget;
        switch (this.status) {
        case 1:
            this.setBought(target);
            break;
        case 2:
            this.setDeleted(target);
        }
    }

    setBought(itemEl) {
        boughtEl.appendChild(itemEl);
        request
            .post('/item/status')
            .send({ name: itemEl.textContent, status: 2 });
    }

    setDeleted(itemEl) {
        let delete = prompt('Really delete?');
        if (!delete) return;
        itemEl.remove();
        request
            .post('/item/status')
            .send({ name: itemEl.textContent, status: 3 });
    }

    getStatus() {
        return this.status;
    }

};
