import { LightningElement, wire } from 'lwc';
import getPic from '@salesforce/apex/ApexCallout.getPexelPic';
import { getLogger } from 'c/logger';

export default class DisplayImage extends LightningElement {
    logger;

    pictureData;

    start;

    async connectedCallback() {
        this.logger = getLogger();
        this.logger.setScenario('DEMO');
        this.start = Date.now();
        this.logger.info(`start was set to ${this.start}`);
        this.logger.saveLog();
    }

    @wire(getPic, {'pageNumber': (Math.random() * 1000).toFixed(0)})
    wiredResponse({error, data}) {
        if(error) {
            console.error(error);
        } 

        if(data) {
            this.logger.debug(JSON.parse(data));
            this.pictureData = JSON.parse(data).photos[0].src.original;
            console.log(`Apex variation took ${Date.now() - this.start}`);
            this.logger.saveLog();
        }
    }

}