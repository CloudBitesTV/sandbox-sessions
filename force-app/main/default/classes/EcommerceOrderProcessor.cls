public with sharing class EcommerceOrderProcessor {
    
    // Requirements:
    // The processOrder method must takean order and create an account, contact and opp with line items.
    // We want to de-duplicate our contacts using the Email field. Multiple contacts per email may exist (we have been untidy)
    // and so we need to handle that scenario, choosing the contact with the most recent opportunity for use.
    // Assumptions that can be made
    // - Standard Pricebook is used and called Standard

    public void processOrder(ECommerceOrder order) {
        //implementation goes here
    }

    public class EcommerceOrder {
        public String salutation;
        public String firstName;
        public String lastName;
        public String email;
        public String phone;
        public String address1;
        public String address2;
        public String city;
        public String zip;
        public String country;
        public Decimal total;
        public Date orderDate;
        public List<ECommercerOrderLineItem> lineItems;
    }

    public class ECommercerOrderLineItem {
        public Decimal unitPrice;
        public Decimal quantity;
        public String productCode;
    }

}