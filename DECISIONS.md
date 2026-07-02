# Decision record

This document contains reasoning behind decisions made during implementation.

## Ruby version upgrade

Ruby 3.0 fails to compile due to outdated GCC toolchain dependency. I upgraded Ruby to the latest Ruby 3 version (3.4.10). Still close enough to original assignment, but less outdated.

## MySQL in Docker

I don't run databases on my local machine. Adding a `docker-compose.yml` file allows any user to run the database in a Docker container, without breaking other local setups. Removing the `socket` definition allows this setup to work on environments other than MacOS with brew.
