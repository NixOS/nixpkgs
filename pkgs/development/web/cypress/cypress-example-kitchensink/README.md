
# `cypress-example-kitchensink`

This directory 'packages' [cypress-example-kitchensink](https://github.com/cypress-io/cypress-example-kitchensink),
which is used in `cypress.passthru.tests`.

The app is not really intended for deployment, so I didn't bother with actual packaging, just testing.
If your real-world app looks like `cypress-example-kitchensink`, you'll want to use Nix multiple outputs so you don't deploy your test videos along with your app.
Alternatively, you can set it up so that one derivation builds your server exe and another derivation takes that server exe and runs it with the cypress e2e tests.

## Peculiarities

**cypress and Cypress** are distinct names.
  - `cypress` is the npm module, containing the executable `cypress`
  - whereas the executable `Cypress` comes from `pkgs.cypress`, a binary distribution (as of writing) by cypress.io.

**updateScript** is not provided for this example project. This seems preferable,
  because updates to it aren't particularly valuable and have a significant overhead.
  The goal is to smoke test `cypress`; not run the latest test suite (which it isn't anyway).

## Updating

 - update the hash in `src.nix`
 - run `regen-nix`
