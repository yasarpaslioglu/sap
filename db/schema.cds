using {
  cuid,
  managed,
  sap.common.CodeList
} from '@sap/cds/common';

namespace sap.capire.incidents;

/**
* Incidents created by Customers.
*/
entity Incidents : cuid, managed {
  customer      : Association to Customers;
  contactPerson : Association to AuthorizedContacts;
  title         : String @title: 'Title';
  urgency       : Association to Urgency default 'M';
  status        : Association to Status default 'N';
  conversation  : Composition of many {
                    key ID        : UUID;
                        timestamp : type of managed : createdAt;
                        author    : type of managed : createdBy;
                        message   : String;
                  };
}

/**
* Customers entitled to create support Incidents.
*/
entity Customers : managed {
  key ID           : String;
      firstName    : String;
      lastName     : String;
      name         : String = trim(firstName || ' ' || lastName);
      email        : EMailAddress;
      phone        : PhoneNumber;
      incidents    : Association to many Incidents
                       on incidents.customer = $self;
      contacts     : Association to many AuthorizedContacts
                       on contacts.customer = $self;
      payments     : Association to many PaymentApprovals
                       on payments.customer = $self;
      creditCardNo : String(16) @assert.format: '^[1-9]\d{15}$';
      addresses    : Composition of many Addresses
                       on addresses.customer = $self;
}

/**
* Authorized contacts for customers.
*/
entity AuthorizedContacts : cuid, managed {
  customer : Association to Customers;
  name     : String @title: 'Contact Name';
  email    : EMailAddress @title: 'Email';
  phone    : PhoneNumber @title: 'Phone';
  role     : String @title: 'Role';
}

/**
* Payment and Approval records for customers.
*/
entity PaymentApprovals : cuid, managed {
  customer       : Association to Customers;
  transactionId  : String @title: 'Transaction ID';
  amount         : Decimal(10, 2) @title: 'Amount';
  currency       : String(3) default 'USD' @title: 'Currency';
  paymentStatus  : String @title: 'Payment Status'; // Paid, Pending, Cancelled
  approvalStatus : String @title: 'Approval Status'; // Approved, Pending Approval, Rejected
  approverName   : String @title: 'Approver Name';
  approvalDate   : DateTime @title: 'Approval Date';
  notes          : String @title: 'Notes';
}

entity Addresses : cuid, managed {
  customer      : Association to Customers;
  city          : String;
  postCode      : String;
  streetAddress : String;
}

entity Status : CodeList {
  key code        : String enum {
        new = 'N';
        assigned = 'A';
        in_process = 'I';
        on_hold = 'H';
        resolved = 'R';
        closed = 'C';
      };
      criticality : Integer;
}

entity Urgency : CodeList {
  key code : String enum {
        high = 'H';
        medium = 'M';
        low = 'L';
      };
}

type EMailAddress : String;
type PhoneNumber  : String;
