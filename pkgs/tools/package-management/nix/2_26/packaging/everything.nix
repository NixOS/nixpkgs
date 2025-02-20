{
  lib,
  stdenv,
  buildEnv,

  nix-util,
  nix-util-c,
  nix-util-tests,

  nix-store,
  nix-store-c,
  nix-store-tests,

  nix-fetchers,
  nix-fetchers-tests,

  nix-expr,
  nix-expr-c,
  nix-expr-tests,

  nix-flake,
  nix-flake-c,
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

  testers,
  runCommand,

  patchedSrc ? null,
}:

let
  libs =
    {
      inherit
        nix-util
        nix-util-c
        nix-store
        nix-store-c
        nix-fetchers
        nix-expr
        nix-expr-c
        nix-flake
        nix-flake-c
        nix-main
        nix-main-c
        nix-cmd
        ;
    }
    // lib.optionalAttrs
      (!stdenv.hostPlatform.isStatic && stdenv.buildPlatform.canExecute stdenv.hostPlatform)
      {
        # Currently fails in static build
        inherit
          nix-perl-bindings
          ;
      };

  dev = stdenv.mkDerivation (finalAttrs: {
    name = "nix-${nix-cli.version}-dev";
    pname = "nix";
    version = nix-cli.version;
    dontUnpack = true;
    dontBuild = true;
    libs = map lib.getDev (lib.attrValues libs);
    nix = nix-cli;
    installPhase = ''
      mkdir -p $out/nix-support
      echo $libs >> $out/nix-support/propagated-build-inputs
      echo $nix >> $out/nix-support/propagated-build-inputs
    '';
    passthru = {
      tests = {
        pkg-config = testers.hasPkgConfigModules {
          package = finalAttrs.finalPackage;
        };
      };

      # If we were to fully emulate output selection here, we'd confuse the Nix CLIs,
      # because they rely on `drvPath`.
      dev = finalAttrs.finalPackage.out;

      libs = throw "`nix.dev.libs` is not meant to be used; use `nix.libs` instead.";
    };
    meta = {
      mainProgram = "nix";
      pkgConfigModules = [
        "nix-cmd"
        "nix-expr"
        "nix-expr-c"
        "nix-fetchers"
        "nix-flake"
        "nix-flake-c"
        "nix-main"
        "nix-main-c"
        "nix-store"
        "nix-store-c"
        "nix-util"
        "nix-util-c"
      ];
    };
  });
  devdoc = buildEnv {
    name = "nix-${nix-cli.version}-devdoc";
    paths = [
      nix-internal-api-docs
      nix-external-api-docs
    ];
  };

  /**
    Produce a set of derivation outputs that implement the multiple outputs interface.

    The multiple outputs interface was originally designed for derivations with
    multiple outputs, but it can also be used for packages which do not correspond
    1:1 to a single derivation and whose outputs come from distinct derivations.
  */
  makeOutputs =
    {
      outputs,
      defaultOutput ? "out",
      extraAttrs ? outputName: value: { },
    }:

    let
      prepOutput =
        outputName: value:
        {
          _type = "package";
          /**
            For compatibility. The outputs of this package may not actually be implemented using a single derivation.
          */
          type = "derivation";
          outputName = outputName;
          outPath = value.outPath or value;
        }
        // extraAttrs outputName value;

      outputAttrs = lib.mapAttrs (
        outputName: value: { outputSpecified = true; } // prepOutput outputName value // commonAttrs
      ) outputs;

      # This is without `outputSpecified`, but otherwise matches the `outputAttrs` above.
      defaultOutputValue = prepOutput defaultOutput outputs.${defaultOutput} // commonAttrs;

      commonAttrs = {
        outputs = builtins.attrNames outputs;
      } // outputAttrs;

    in
    defaultOutputValue;

in

makeOutputs {
  extraAttrs = outputName: drv: {
    meta = drv.meta // {
      description = "The Nix package manager";
      pkgConfigModules = dev.meta.pkgConfigModules;
      outputsToInstall = [
        # man is symlinked
        "out"
      ];
    };
    internals = drv;
    name = "nix";
    overrideAttrs =
      _:
      throw "The nix package does not support overrideAttrs, because it has been split into multiple derivations. Instead, you may call attributes such as overrideSource, appendPatches or overrideAllMesonComponents.";
    inherit (nix-cli) version;
    # Should not be required
    inherit (drv) drvPath;
    /**
      The build platform's system string, used by Nix to dispatch derivations to the correct kinds of hosts.

      This particular attribute is _not_ used for that purpose, but it has the same value, and some other expressions expect it to be present.
    */
    inherit (drv) system;
    tests = drv.tests or {};
    src = patchedSrc;
  };
  outputs = {
    inherit dev devdoc;
    doc = nix-manual;
    out =
      (buildEnv {
        name = "nix-${nix-cli.version}";
        paths = [
          nix-cli
          nix-manual.man
        ];
        meta.mainProgram = "nix";
      }).overrideAttrs
        (
          finalAttrs: prevAttrs: {
            doCheck = true;
            doInstallCheck = true;

            checkInputs =
              [
                # Make sure the unit tests have passed
                nix-util-tests.tests.run
                nix-store-tests.tests.run
                nix-expr-tests.tests.run
                nix-fetchers-tests.tests.run
                nix-flake-tests.tests.run

                # Make sure the functional tests have passed
                nix-functional-tests

                # dev bundle is ok
                # (checkInputs must be empty paths??)
                (runCommand "check-pkg-config" { checked = dev.tests.pkg-config; } "mkdir $out")
              ]
              ++ lib.optionals
                (!stdenv.hostPlatform.isStatic && stdenv.buildPlatform.canExecute stdenv.hostPlatform)
                [
                  # Perl currently fails in static build
                  # TODO: Split out tests into a separate derivation?
                  nix-perl-bindings
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
              inherit libs;

              tests = prevAttrs.passthru.tests or { } // {
                # TODO: create a proper fixpoint and:
                pkg-config = testers.hasPkgConfigModules {
                  package = finalAttrs.finalPackage;
                };
              };
            };
          }
        );
  };
}
