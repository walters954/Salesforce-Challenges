import { LightningElement, wire, track } from 'lwc';
import  getAccountList from '@salesforce/apex/AccountPaymentController.getAccountList';
import voidPayments from '@salesforce/apex/AccountPaymentController.voidPayments';
import { refreshApex } from '@salesforce/apex';

export default class AccountPayment extends LightningElement {

        @track data;
        @track error;
        @track columns = [
            { label: 'Name', fieldName: 'Name'},
            { label: '# of Payments', fieldName: 'Number_of_Non_void_Payments__c', type : 'number'},
            { label: 'Void Payments', type: "button", typeAttributes: {
                label: 'Void',
                name: 'Void',
                title: 'Void',
                disabled: false,
                value: 'void',
                iconPosition: 'center'
            }}
        ];

        accountData; 

        //get account list
        @wire(getAccountList)
        wireAccounts(result){
            this.accountData = result;
            if (result.data) {
                this.data = result.data;
                this.error = undefined;
            } else if (result.error) {
                this.error = result.error;
                this.accounts = undefined;
            }
        }

        //button void press void all payments
        handleRowAction(event) {
            const row = event.detail.row;
            voidPayments({accountId : row.Id}).then(() => {
                return refreshApex(this.accountData);
            });
        }
}