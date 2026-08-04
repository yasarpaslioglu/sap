using {sap.capire.incidents as my} from '../db/schema';

/**
 * Service used by support personell, i.e. the incidents' 'processors'.
 */
service ProcessorService {
    entity Incidents as projection on my.Incidents {
        *,
        case status.code when 'C' then 1 else 3 end as isClosed : Integer
    };

    @readonly
    entity Customers as projection on my.Customers;

    entity AuthorizedContacts as projection on my.AuthorizedContacts;

    entity PaymentApprovals as projection on my.PaymentApprovals;
}
annotate ProcessorService.Incidents with @odata.draft.enabled;
annotate ProcessorService with @(requires: 'support');

/**
 * Service used by administrators to manage customers, contacts, payments and incidents.
 */
service AdminService {
    entity Customers as projection on my.Customers;
    entity Incidents as projection on my.Incidents;
    entity AuthorizedContacts as projection on my.AuthorizedContacts;
    entity PaymentApprovals as projection on my.PaymentApprovals;
}
annotate AdminService with @(requires: 'admin');