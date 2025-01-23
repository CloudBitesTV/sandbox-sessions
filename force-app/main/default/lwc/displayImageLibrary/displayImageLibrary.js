import { LightningElement } from 'lwc';
import {createClient} from 'c/pexelsLibrary';
import { retrieveAPIKey } from 'c/pexelsAPIKey';

export default class DisplayImageLibrary extends LightningElement {

    pictureData;
    
    connectedCallback(){
        const client = createClient(retrieveAPIKey());
        
        let pageNum = (Math.random() * 1000).toFixed(0);

        client.photos.curated({ per_page: 1 , page: pageNum})
            .then(response => {
                this.pictureData = response.photos[0].src.original;
            });
    }
}