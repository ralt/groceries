let $ = x => document.querySelector(x);
let clearEl = $('#clear');

export default class Clear {

    constructor(list) {
        this.list = list;
    }

    setupListeners() {
        let self = this;
        clearEl.addEventListener('click', () => {
            let really = confirm('Really clear list?');
            if (!really) return;
            self.list.clear();
        });
    }

};
