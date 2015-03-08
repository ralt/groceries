export default class Clear {

    constructor(list) {
        this.list = list;
    }

    setupListeners() {
        let self = this;
        clearEl.addEventListener('click', () => {
            self.list.clear();
        });
    }

};
