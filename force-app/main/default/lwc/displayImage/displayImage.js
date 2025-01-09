import { LightningElement, wire } from 'lwc';
import getPic from '@salesforce/apex/ApexCallout.getPexelPic';

export default class DisplayImage extends LightningElement {

    pictureData;

    start;

    connectedCallback() {
        this.start = Date.now();
    }

    @wire(getPic, {'pageNumber': (Math.random() * 1000).toFixed(0)})
    wiredResponse({error, data}) {
        if(error) {
            console.error(error);
        } 

        if(data) {
            console.log(JSON.parse(data));
            this.pictureData = JSON.parse(data).photos[0].src.original;
            console.log(`Apex variation took ${Date.now() - this.start}`);
        }
    }

}