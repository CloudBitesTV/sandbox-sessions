import { api } from 'lwc';
import { gql, executeMutation } from "lightning/graphql";
import LightningModal from 'lightning/modal';

export default class CreateContactModal extends LightningModal {
    @api accountId;

    firstName;
    lastName;
    email;

    handleFirstNameChange(event) {
        this.firstName = event.target.value;
    }

    handleLastNameChange(event) {
        this.lastName = event.target.value;
    }

    handleEmailChange(event) {
        this.email = event.target.value;
    }

    get createContactMutation() {
        return gql`
            mutation ContactCreateMutation($input: ContactCreateInput!) {
                uiapi(input: { allOrNone: false }) {
                    ContactCreate(input: $input) {
                        Record {
                            Id
                        }
                    }
                }
            }
        `;
    }

    async handleSave() {
        try {
            const result = await executeMutation({
                query: this.createContactMutation,
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
        } catch (error) {
            console.error('Mutation error:', JSON.stringify(error, null, 2));
            console.error('Error details:', error);
        }
    }

    handleCancel() {
        this.close('cancel');
    }
}