# CaseCsContactManager
An exercise project

## How to run
- Execute `docker-compose up -d` to start up postgres, pg-admin and the web app
- The web container will start fast, but the app won't be available until the project is compiled (see `./dev.sh`). You can monitor progress with `docker container logs -f <container_id>`
- Access 
  - the **web app** on http://localhost:4000
  - **pgadmin** on http://localhost:5050 (`user: pgadmin4@pgadmin.org, pass: admin`)

## Notes

### Login process
The requirement was to use a sample jwt token & public RSA key for authenticating requests using the Authorization header. This would make usage by human operators too difficult, as there would be a need for setting the header on each request. So I decided to use Guardian and the token & public key pair for a somewhat unconventional login process using the token itself on submission (as there was no private key for signing a new token from username/pass) and then storing the user_id in an encrypted session cookie.

### Home page
To make browsing easier when visiting the homepage at '/' you can see a list of case ids that have contacts associated with them. Although _cases_ are strictly not a thing a _contacts_ service should be concerned with, I decided to add it for the sake of ease of use.

### Auditing
In most cases where auditing is of paramount importance audit usually happens within the same transaction. But as per document instructions the intention was to log audit messages from a different service while also making sure that producing audit messages would not be overly slow- both of which preclude audit logs from being written as part of the same transaction. What happens instead is publishing a new internal event with audit log details (see `Contacts.publish_change/4`) so that in the future the system can be extended with a separate process listening for such messages and re-publishing to the actual auditing app.

While on the subject of auditing, I decided not to produce audit logs for listing contacts; but at the same time made sure to reduce visible data to only `{id, update_at}` so no PII would leak from listing

### Testing
To test controller functionality I used a different jwt token/public key pair that you can find hard coded in the `test_helper.exs` file (to avoid 'leaking' the given keys)

To run the tests using the provided docker container change the db hostname to `hostname: contacts-postgres` inside the `config/test.exs`