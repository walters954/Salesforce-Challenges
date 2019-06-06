import { LightningElement, wire, track } from 'lwc';
import getAccountList from '@salesforce/apex/AccountPaymentController.getAccountList';


export default class AccountPayment extends LightningElement {

        @track data;
        @track error;
        @track columns = [
            { label: 'Name', fieldName: 'Name'},
            { label: '# of Payments', fieldName: 'Number_of_Non_void_Payments__c'},
            {type: "button", typeAttributes: {
                label: 'Edit',
                name: 'Edit',
                title: 'Edit',
                disabled: false,
                value: 'edit',
                iconPosition: 'left'
            }}
        ];

        @wire(getAccountList)
        wireAccounts({
            error,
            data
        }) {
            if(data){
                this.data = data;
                // eslint-disable-next-line no-console
                console.log(data);
                // eslint-disable-next-line no-console
                console.log(JSON.stringify(data, null, '\t'));
            } else if (error){
                this.error = error;
            }
        }

        

}