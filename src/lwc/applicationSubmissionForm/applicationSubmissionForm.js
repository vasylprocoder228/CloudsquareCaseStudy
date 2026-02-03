import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import processApplication from '@salesforce/apex/ApplicationProcessingService.processApplication';

export default class ApplicationSubmissionForm extends LightningElement {
    @track formData = {
        companyName: '',
        email: '',
        phone: '',
        contactFirstName: '',
        contactLastName: '',
        federalTaxId: '',
        annualRevenue: null,
        source: 'Community'
    };

   isLoading = false;


    handleInputChange(event) {
        const field = event.target.dataset.field;
        const value = event.target.value;
        this.formData[field] = value;
    }


    handleSubmit(event) {
        event.preventDefault();
        this.isLoading = true;

        processApplication({
            submission: this.formData
        })
            .then(result => {
                if (result.success) {
                    this.handleSuccess(result);
                } else {
                    this.showToast('Error', result.message, 'error');
                }
            })
            .catch(error => {
                console.error('Error submitting application:', error);
                this.showToast(
                    'Error',
                    this.getErrorMessage(error),
                    'error'
                );
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    handleSuccess(result) {

        this.showToast(
            'Success',
            result.message,
            'success'
        );
    }

    getErrorMessage(error) {
        if (error.body) {
            if (error.body.message) {
                return error.body.message;
            }
            if (error.body.pageErrors && error.body.pageErrors.length > 0) {
                return error.body.pageErrors[0].message;
            }
        }
        return 'An unexpected error occurred. Please try again.';
    }


    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }


    get submitButtonDisabled() {
        return this.isLoading;
    }


    get showSpinner() {
        return this.isLoading;
    }
}