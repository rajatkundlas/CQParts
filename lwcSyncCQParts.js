import { LightningElement } from 'lwc';
import syncPartsCallout from '@salesforce/apex/CQPartSyncController.syncPartsCallout';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
export default class LwcSyncCQParts extends LightningElement {

    handleClick()
    {
        syncPartsCallout().then(result => {
            this.showNotification('Sucessss', 'Parts Synced', 'success');            
        }).catch(error => {
            this.showNotification('Error', error.body.message, 'error');
        });
    }

    showNotification(notitifcationTitle, notificationMessage, notificationVariant)
    {
        const newEvent = new ShowToastEvent({
            title: notitifcationTitle,
            message:notificationMessage,
            variant: notificationVariant
        });
        this.dispatchEvent(newEvent);
    }
}