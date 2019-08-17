import { LightningElement, track } from 'lwc';

export default class EbikeExample extends LightningElement {
    name = 'Electra X4';
    description = 'A bike';
    category = 'Mountain';
    material = 'steel';
    price = '$2,700';
    pictureURL = 'https://s3-us-west-1.amazonaws.com/sfdc-demo/ebikes/electrax4.jpg';

    @track
   ready = false;
   connectedCallback() {
       setTimeout(() => {
           this.ready = true;
       }, 3000);
   }
}