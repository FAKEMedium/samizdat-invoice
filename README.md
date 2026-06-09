# Samizdat-Plugin-Invoice

Invoicing for [Samizdat](https://fakenews.com) — operator back-office: create,
credit, remind, and take payment on invoices, with subscriptions and products.
Extracted from the Samizdat monorepo with history; installs as a standalone
CPAN/pkg distribution.

## Layout

    lib/Samizdat/Plugin/Invoice.pm         routes + the `invoice` helper
    lib/Samizdat/Controller/Invoice.pm     request handlers
    lib/Samizdat/Model/Invoice.pm          invoicing business logic / data access
    lib/Samizdat/Command/invoice.pm        `samizdat invoice` command
    lib/Samizdat/resources/templates/invoice/    operator UI (create/credit/remind/pay/handle/open)
    lib/Samizdat/resources/templates/customer/…   customer-facing invoice views (this dist owns them)
    lib/Samizdat/resources/templates/chunks/invoicetable.html.ep   shared invoice table chunk
    lib/Samizdat/resources/settings/invoice/      JSON-Schema config contract
    lib/Samizdat/resources/locale/invoice/        per-module translations

Resources install under `site_perl/Samizdat/resources/...`, where the core
resolver (`$app->resource(...)`) finds them.

## Dependencies

- **Samizdat** (core) — **required**: provides the `Customer` plugin (this plugin's
  routes display customer invoice data and must load after Customer), plus
  `Samizdat::Model::Cache` and the settings resolver. Not yet on CPAN; install the
  core dist or put it on `PERL5LIB`.
- **Samizdat-Plugin-Fortnox** — *optional*: when installed and enabled
  (`manager.invoice.usefortnox`), invoice numbers and credit/booking are synced to
  Fortnox. Every call is guarded by helper-detection, so Invoice runs fine without it.
- Mojolicious, Hash::Merge.

## Install

    perl Makefile.PL
    make && make test          # core (Samizdat) must be on PERL5LIB
    make install               # or: make install INSTALL_BASE=/path/to/prefix

Enable it in `samizdat.yml` via `extraplugins: [Invoice]` (after `Customer`/core)
and configure `manager.invoice` (see
`lib/Samizdat/resources/settings/invoice/schema.yml` for the defaults).
