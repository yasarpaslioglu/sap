using ProcessorService as service from '../../srv/services';
using from '../../db/schema';

annotate service.Incidents with @(
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : title,
            },
            {
                $Type : 'UI.DataField',
                Label : '{i18n>Customer}',
                Value : customer_ID,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Authorized Contact',
                Value : contactPerson_ID,
            },
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.CollectionFacet',
            Label : '{i18n>Overview}',
            ID : 'i18nOverview',
            Facets : [
                {
                    $Type : 'UI.ReferenceFacet',
                    ID : 'GeneratedFacet1',
                    Label : '{i18n>GeneralInformation}',
                    Target : '@UI.FieldGroup#GeneratedGroup',
                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : '{i18n>Details}',
                    ID : 'i18nDetails',
                    Target : '@UI.FieldGroup#i18nDetails',
                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : 'Authorized Contact Details',
                    ID : 'ContactDetailsFacet',
                    Target : '@UI.FieldGroup#ContactDetails',
                },
            ],
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Payment Approvals',
            ID : 'PaymentApprovalsFacet',
            Target : 'customer/payments/@UI.LineItem',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : '{i18n>Conversation}',
            ID : 'i18nConversation',
            Target : 'conversation/@UI.LineItem#i18nConversation',
        },
    ],
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Value : title,
            Label : '{i18n>Title}',
        },
        {
            $Type : 'UI.DataField',
            Value : customer.name,
            Label : '{i18n>Customer}',
        },
        {
            $Type : 'UI.DataField',
            Value : contactPerson.name,
            Label : 'Authorized Contact',
        },
        {
            $Type : 'UI.DataField',
            Value : status.descr,
            Label : '{i18n>Status}',
            Criticality : status.criticality,
        },
        {
            $Type : 'UI.DataField',
            Value : urgency.descr,
            Label : '{i18n>Urgency}',
        },
    ],
    UI.SelectionFields : [
        status_code,
        urgency_code,
    ],
    UI.HeaderInfo : {
        Title : {
            $Type : 'UI.DataField',
            Value : title,
        },
        TypeName : 'Incident',
        TypeNamePlural : 'Incidents',
        Description : {
            $Type : 'UI.DataField',
            Value : customer.name,
        },
        TypeImageUrl : 'sap-icon://alert',
    },
    UI.FieldGroup #i18nDetails : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : status_code,
            },
            {
                $Type : 'UI.DataField',
                Value : urgency_code,
            },
        ],
    },
    UI.FieldGroup #ContactDetails : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : contactPerson.name,
                Label : 'Name',
            },
            {
                $Type : 'UI.DataField',
                Value : contactPerson.email,
                Label : 'Email',
            },
            {
                $Type : 'UI.DataField',
                Value : contactPerson.phone,
                Label : 'Phone',
            },
            {
                $Type : 'UI.DataField',
                Value : contactPerson.role,
                Label : 'Role',
            },
        ],
    },
);

annotate service.Incidents with {
    customer @(
        Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'Customers',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : customer_ID,
                    ValueListProperty : 'ID',
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'name',
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'email',
                },
            ],
        },
        Common.Text : customer.name,
        Common.Text.@UI.TextArrangement : #TextOnly,
        Common.ValueListWithFixedValues : false,
    );

    contactPerson @(
        Common.Label : 'Authorized Contact',
        Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'AuthorizedContacts',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : contactPerson_ID,
                    ValueListProperty : 'ID',
                },
                {
                    $Type : 'Common.ValueListParameterIn',
                    LocalDataProperty : customer_ID,
                    ValueListProperty : 'customer_ID',
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'name',
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'role',
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'phone',
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'email',
                },
            ],
        },
        Common.Text : contactPerson.name,
        Common.Text.@UI.TextArrangement : #TextOnly,
    );
};

annotate service.Incidents with {
    status @(
        Common.Label : '{i18n>Status}',
        Common.ValueListWithFixedValues : true,
        Common.Text : status.descr,
    )
};

annotate service.Incidents with {
    urgency @(
        Common.Label : '{i18n>Urgency}',
        Common.ValueListWithFixedValues : true,
        Common.Text : urgency.descr,
    )
};

annotate service.AuthorizedContacts with @(
    UI.LineItem : [
        { Value : name, Label : 'Name' },
        { Value : role, Label : 'Role' },
        { Value : phone, Label : 'Phone' },
        { Value : email, Label : 'Email' },
    ]
);

annotate service.PaymentApprovals with @(
    UI.LineItem : [
        { Value : transactionId, Label : 'Transaction ID' },
        { Value : amount, Label : 'Amount' },
        { Value : currency, Label : 'Currency' },
        { Value : paymentStatus, Label : 'Payment Status' },
        { Value : approvalStatus, Label : 'Approval Status' },
        { Value : approverName, Label : 'Approver Name' },
        { Value : approvalDate, Label : 'Approval Date' },
        { Value : notes, Label : 'Notes' },
    ]
);

annotate service.Status with {
    code @Common.Text : descr
};

annotate service.Urgency with {
    code @Common.Text : descr
};

annotate service.Incidents.conversation with @(
    UI.LineItem #i18nConversation : [
        {
            $Type : 'UI.DataField',
            Value : author,
            Label : '{i18n>Author}',
        },
        {
            $Type : 'UI.DataField',
            Value : message,
            Label : '{i18n>Message}',
        },
        {
            $Type : 'UI.DataField',
            Value : timestamp,
            Label : '{i18n>Date}',
        },
    ]
);

annotate service.Incidents with {
    title         @Common.FieldControl : isClosed;
    customer      @Common.FieldControl : isClosed;
    contactPerson @Common.FieldControl : isClosed;
    urgency       @Common.FieldControl : isClosed;
};
