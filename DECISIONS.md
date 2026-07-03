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

## Battle action attempts always return 200

Since an escape from a battle can fail, I considered returning a `417` or `422` response in case of failure, but that
goes against REST expectations and I decided against it. Instead I opted for calling the resource an `EscapeAttempt`.
The attempt will always be created, but can have different outcomes.

## Added standardrb for linting

Add standardrb for a no-setup linting tool

## Pokemon stat calculation

The README file states two requirements relating to pokemon stats based on levels. None of the existing documentation or
code accommodates that. I asked AI for the official Pokemon stat formula:

Real Pokémon games compute this from base stat, IV, EV, and Nature — none of which this schema models. The real Gen 3+ formula with IV = 0, EV = 0, and Nature neutral is:

```
HP    = floor(2 * base * level / 100) + level + 10
other = floor(2 * base * level / 100) + 5
```

This will be added in `BasePokemon#stat_at_level`.

