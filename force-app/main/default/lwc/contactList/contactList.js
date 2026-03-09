import { LightningElement, api, wire } from 'lwc';
import { gql, graphql } from "lightning/graphql";
import createContactModal from "c/createContactModal";

export default class ContactList extends LightningElement {
    @api recordId = '';

    records = [];
    _refresh;

    @wire(graphql, {
        query: gql`
            query relatedContact($accId: ID) {
                uiapi {
                    query {
                        Contact(where: {AccountId: {eq: $accId}}) {
                            edges {
                                node {
                                    Id,
                                    Name {
                                        value
                                    },
                                    Email {
                                        value
                                    }
                                }
                            }
                        }
                    }
                }
            }
    `,
        variables: "$variables"
    })
    graphqlResultHandler({ data, errors, refresh }) {
        if(data) {
            this.records = data.uiapi.query.Contact.edges.map((edge) => edge.node);
            this._refresh = refresh
        }

        if(errors) {
            console.error(errors);
        }
    }

    get variables() {
        return { accId: this.recordId };
    }

    async handleNew() {
        const result = await createContactModal.open( {
            accountId: this.recordId,
            size: 'small'
        });
        if(result === 'success') {
            return this._refresh();
        }
        return null;
    }

}