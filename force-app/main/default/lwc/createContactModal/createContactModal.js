import { api } from 'lwc';
import LightningModal from 'lightning/modal';
import { gql, executeMutation } from "lightning/graphql";
import FirstName from '@salesforce/schema/Contact.FirstName';

export default class CreateContactModal extends LightningModal {

    @api accountId;

    firstName;
    lastName;
    email;

    get contactCreationQuery() {
        return gql`
            mutation ContactCreateMutation($input: ContactCreateInput!) {
                uiapi {
                    ContactCreate(input: $input) {
                        Record {
                            Id
                        }
                    }
                }
            }
        `;
    }

    handleFirstNameChange(event) {
        this.firstName = event.target.value;
    }

    handleLastNameChange(event) {
        this.lastName = event.target.value;
    }

    handleEmailChange(event) {
        this.email = event.target.value;
    }

    handleCancel() {
        this.close('cancel');
    }

    async handleSave() {
        try {
            const result = await executeMutation( {
                query: this.contactCreationQuery,
                variables: {
                    input: {
                        Contact: {
                            AccountId: this.accountId,
                            FirstName: this.firstName,
                            LastName: this.lastName,
                            Email: this.email
                        }
                    }
                }
            });
            this.close('success');
        } catch(error) {
            console.error(error);
            this.handleCancel();
        }
    }
}