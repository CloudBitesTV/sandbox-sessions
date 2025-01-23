import { LightningElement } from 'lwc';
import { retrieveAPIKey } from 'c/pexelsAPIKey';

export default class DisplayImageFetch extends LightningElement {

    pictureData;

    start;

    connectedCallback() {
        this.start = Date.now();

        this.makeCallout();

    }
    
    async makeCallout(){
        
        let pageNum = (Math.random() * 1000).toFixed(0); 
        const response = await fetch(`https://api.pexels.com/v1/curated?per_page=1&page=${pageNum}`, {
            headers: {
                "Authorization" : retrieveAPIKey()
            }
        });

        let jsonBody = await response.json();

        this.pictureData = jsonBody.photos[0].src.original;

        // console.log(`Fetch variation took ${Date.now() - this.start}`);
    }

}