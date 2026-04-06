Lab 5 – Multi-Tenant Booking System with Event-Sourced Audit Trail

Problem to solve
Create a small SaaS-style booking system (e.g., appointments) with multi-tenant support, using an event-sourced audit trail backed by Aurora.

Core services

    API Gateway + Lambda (booking API)
    Aurora (tenants, users, bookings, event_log tables)
    EventBridge (BookingCreated, BookingUpdated, BookingCancelled)
    SQS (audit-processing queue)
    SNS (critical booking alerts to admins)

Criteria for success

    Tenant-aware API: X-Tenant-Id header determines tenant context.
    Every booking mutation writes:
        a “current state” row in bookings
        an event row in booking_events in Aurora
        AND publishes an event to EventBridge.
    A separate Lambda, subscribed to SQS (fed from EventBridge), writes a denormalized audit log table for reporting.
    SNS notification triggers when:
        more than N bookings are cancelled in a short time window for a tenant.
    Git repo contains the schema, Terraform, and a simple demo script.
