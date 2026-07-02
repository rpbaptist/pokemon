# Decision record

This document contains reasoning behind decisions made during implementation.

## Ruby version upgrade

Ruby 3.0 fails to compile due to outdated GCC toolchain dependency. I upgraded Ruby to the latest Ruby 3 version (3.4.10). Still close enough to original assignment, but less outdated.

## Gemfile / Rails upgrade

Bumping Ruby to 3.4.10 cascaded into several dependent fixes:

- Bundler mismatch: the bundler vendored with the Ruby install (2.2.3) predates Ruby 3.4/4.0's DidYouMean API changes, causing uninitialized constant DidYouMean::SPELL_CHECKERS. Fixed by installing a current bundler (gem install bundler).
- nio4r native extension: Rails 7.0.4's locked nio4r 2.5.8 used a C callback signature (rb_ensure) that Ruby 3.4's stricter type checking rejects, so the native extension failed to compile. Rather than patch a pinned gem, bumped Rails 7.0.4 → 7.1.6, which pulls in a newer nio4r (2.7.5) transitively.
- Ruby 3.4 default-gem removals: base64, bigdecimal, logger, mutex_m, ostruct, and csv were unbundled from Ruby's default gems in 3.4, so code that used them without a require (or without the gem declared) broke. Rails 7.1.6's own gemspecs already declare base64/bigdecimal/logger/mutex_m as dependencies, so those are pulled in automatically. Only csv (used directly by httparty) and ostruct (used directly by jbuilder) still needed explicit gem entries in the Gemfile, since those two gems don't declare the dependency themselves.
- Removed sassc-rails: unused — no .scss/.sass files in the app, styling is handled entirely by tailwindcss-rails.

## MySQL in Docker

I don't run databases on my local machine. Adding a `docker-compose.yml` file allows any user to run the database in a Docker container, without breaking other local setups. Removing the `socket` definition allows this setup to work on environments other than MacOS with brew.

## Update `POKEMON_API_URI`

v7 from the `.env` file was no longer functioning. Moving to v8 solved that issue.
