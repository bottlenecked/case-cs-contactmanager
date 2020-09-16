# CaseCsContactManager
An exercise project

## How to run
- Execute `docker-compose up -d` to start up postgres, pg-admin and the web app
- The web container will start fast, but the app won't be available until the project is compiled (see `./dev.sh`). You can monitor progress with `docker container logs -f <container_id>`
- Access 
  - the **web app** on http://localhost:4000
  - **pgadmin** on http://localhost:5050 (`user: pgadmin4@pgadmin.org, pass: admin`)