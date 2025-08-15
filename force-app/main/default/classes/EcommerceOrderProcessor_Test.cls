@isTest
private with sharing class EcommerceOrderProcessor_Test {
    
    @TestSetup
    static void makeData(){
        Account testAccount = new Account();
        testAccount.Name = 'Test Account';
        insert testAccount;

        Contact testContact = new Contact();
        testContact.FirstName = 'Test';
        testContact.LastName = 'Contact';
        testContact.Email = 'test@example.com';
        testContact.Account = testAccount;
        insert testContact;

        Product2 widget = new Product2();
        widget.Name = 'Widget';
        widget.productCode = 'WDGT';
        widget.isActive = true;
        
        Product2 sprocket = new Product2();
        sprocket.Name = 'Sprocket';
        sprocket.productCode = 'SPRKT';
        sprocket.isActive = true;

        insert new List<Product2>{ widget, sprocket };
        
        Id pricebookId = Test.getStandardPricebookId();

        PricebookEntry widgetPrice = new PricebookEntry();
        widgetPrice.PriceBook2Id = pricebookId;
        widgetPrice.Product2Id = widget.Id;
        widgetPrice.IsActive = true;
        widgetPrice.UnitPrice = 13;

        PricebookEntry sprocketPrice = new PricebookEntry();
        sprocketPrice.PriceBook2Id = pricebookId;
        sprocketPrice.Product2Id = sprocket.Id;
        sprocketPrice.IsActive = true;
        sprocketPrice.UnitPrice = 17;

        insert new List<PricebookEntry>{ widgetPrice, sprocketPrice };
    }

    static EcommerceOrderProcessor.EcommerceOrder getTestOrder() {
        EcommerceOrderProcessor.EcommerceOrder testOrder = new EcommerceOrderProcessor.EcommerceOrder();
        testOrder.firstName = 'May';
        testOrder.lastName = 'Dupp';
        testOrder.salutation = 'Ms';
        testOrder.email = 'may.dupp@example.com';
        testOrder.phone = '07700 900999';
        testOrder.address1 = '221B Baker Street';
        testOrder.address2 = 'Marylebone';
        testOrder.city = 'London';
        testOrder.zip = 'NW1 6XE';
        testOrder.country = 'UK';
        testOrder.total = 184;
        testOrder.orderDate = Date.today();

        EcommerceOrderProcessor.ECommercerOrderLineItem widgetLine = new EcommerceOrderProcessor.ECommercerOrderLineItem();
        widgetLine.productCode = 'WDGT';
        widgetLine.quantity = 5;
        widgetLine.unitPrice = 13;

        EcommerceOrderProcessor.ECommercerOrderLineItem sprocketLine = new EcommerceOrderProcessor.ECommercerOrderLineItem();
        sprocketLine.productCode = 'SPRKT';
        sprocketLine.quantity = 7;
        sprocketLine.unitPrice = 17;

        testOrder.lineItems = new List<EcommerceOrderProcessor.ECommercerOrderLineItem>{ widgetLine, sprocketLine };

        return testOrder;
    }

    static EcommerceOrderProcessor.EcommerceOrder getTestOrderWithDuplicateContact() { 
        EcommerceOrderProcessor.EcommerceOrder testOrder = getTestOrder();
        testOrder.email = 'test@example.com';
        return testOrder;
    }
}