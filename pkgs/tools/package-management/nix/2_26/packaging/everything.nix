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

  dev =
    nixAttrs:
    stdenv.mkDerivation (finalAttrs: {
      name = "nix-${nix-cli.version}-dev";
      pname = "nix";
      version = nix-cli.version;
      dontUnpack = true;
      dontBuild = true;
      libs = map lib.getDev (lib.attrValues libs);
      installPhase = ''
        mkdir -p $out/nix-support
        echo $libs >> $out/nix-support/propagated-build-inputs
        echo ${nixAttrs.finalPackage} >> $out/nix-support/propagated-build-inputs
      '';
      passthru = {
        tests = {
          # TODO: is this supposed to work for a dev output?
          # pkg-config = testers.hasPkgConfigModules {
          #   package = finalAttrs.finalPackage;
          # };
        };

        # If we were to fully emulate output selection here, we'd confuse the Nix CLIs,
        # because they rely on `drvPath`.
        dev = finalAttrs.finalPackage.out;
        out = nixAttrs.finalPackage.out;

        libs = throw "`nix.dev.libs` is not meant to be used; use `nix.libs` instead.";
      };
      meta = {
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

in
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
          pkg-config = testers.hasPkgConfigModules {
            package = finalAttrs.finalPackage;
          };
        };

        /**
          A derivation referencing the `dev` outputs of the Nix libraries.
        */
        dev = dev finalAttrs;
        inherit devdoc;
        doc = nix-manual;
        outputs = [
          "out"
          "dev"
          "devdoc"
          "doc"
        ];
        all = lib.attrValues (
          lib.genAttrs finalAttrs.passthru.outputs (outName: finalAttrs.finalPackage.${outName})
        );
      };
      meta = prevAttrs.meta // {
        description = "The Nix package manager";
        pkgConfigModules = (dev finalAttrs).meta.pkgConfigModules;
      };
    }
  )
