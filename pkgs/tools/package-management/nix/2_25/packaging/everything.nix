{
  lib,
  stdenv,
  buildEnv,

  nix-util,
  nix-util-c,
  nix-util-test-support,
  nix-util-tests,

  nix-store,
  nix-store-c,
  nix-store-test-support,
  nix-store-tests,

  nix-fetchers,
  nix-fetchers-tests,

  nix-expr,
  nix-expr-c,
  nix-expr-test-support,
  nix-expr-tests,

  nix-flake,
  nix-flake-tests,

  nix-main,
  nix-main-c,

  nix-cmd,

  nix-cli,

  nix-functional-tests,

  nix-manual,
  nix-internal-api-docs,
  nix-external-api-docs,

  nix-perl-bindings,
}:

(buildEnv {
  name = "nix-${nix-cli.version}";
  paths = [
    nix-util
    nix-util-c
    nix-util-test-support
    nix-util-tests

    nix-store
    nix-store-c
    nix-store-test-support
    nix-store-tests

    nix-fetchers
    nix-fetchers-tests

    nix-expr
    nix-expr-c
    nix-expr-test-support
    nix-expr-tests

    nix-flake
    nix-flake-tests

    nix-main
    nix-main-c

    nix-cmd

    nix-cli

    nix-manual
    nix-internal-api-docs
    nix-external-api-docs

  ] ++ lib.optionals (stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    nix-perl-bindings
  ];

  meta.mainProgram = "nix";
}).overrideAttrs (finalAttrs: prevAttrs: {
  doCheck = true;
  doInstallCheck = true;

  checkInputs = [
    # Actually run the unit tests too
    nix-util-tests.tests.run
    nix-store-tests.tests.run
    nix-expr-tests.tests.run
    nix-flake-tests.tests.run
  ];
  installCheckInputs = [
    nix-functional-tests
  ];
  passthru = prevAttrs.passthru // {
    inherit (nix-cli) version;

    /**
      These are the libraries that are part of the Nix project. They are used
      by the Nix CLI and other tools.

      If you need to use these libraries in your project, we recommend to use
      the `-c` C API libraries exclusively, if possible.

      We also recommend that you build the complete package to ensure that the unit tests pass.
      You could do this in CI, or by passing it in an unused environment variable. e.g in a `mkDerivation` call:

      ```nix
        buildInputs = [ nix.libs.nix-util-c nix.libs.nix-store-c ];
        # Make sure the nix libs we use are ok
        unusedInputsForTests = [ nix ];
        disallowedReferences = nix.all;
      ```
     */
    libs = {
      inherit
        nix-util
        nix-util-c
        nix-store
        nix-store-c
        nix-fetchers
        nix-expr
        nix-expr-c
        nix-flake
        nix-main
        nix-main-c
      ;
    };
  };
})
