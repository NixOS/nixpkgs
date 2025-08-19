{
  lib,
  stdenv,
  lndir,
  buildEnv,

  maintainers,
  teams,

  version,

  nix-util,
  nix-util-c,
  nix-util-tests,

  nix-store,
  nix-store-c,
  nix-store-tests,

  nix-fetchers,
  nix-fetchers-c,
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

  patchedSrc ? null,
}:

let
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
      nix-flake-c
      nix-main
      nix-main-c
      nix-cmd
      ;
  }
  // lib.optionalAttrs (lib.versionAtLeast version "2.29pre") {
    inherit
      nix-fetchers-c
      ;
  }
  //
    lib.optionalAttrs
      (!stdenv.hostPlatform.isStatic && stdenv.buildPlatform.canExecute stdenv.hostPlatform)
      {
        # Currently fails in static build
        inherit
          nix-perl-bindings
          ;
      };

  devdoc = buildEnv {
    name = "nix-${nix-cli.version}-devdoc";
    paths = [
      nix-internal-api-docs
      nix-external-api-docs
    ];
  };

in
stdenv.mkDerivation (finalAttrs: {
  pname = "nix";
  version = nix-cli.version;

  /**
    This package uses a multi-output derivation, even though some outputs could
    have been provided directly by the constituent component that provides it.

    This is because not all tooling handles packages composed of arbitrary
    outputs yet. This includes nix itself, https://github.com/NixOS/nix/issues/6507.

    `devdoc` is also available, but not listed here, because this attribute is
    not an output of the same derivation that provides `out`, `dev`, etc.
  */
  outputs = [
    "out"
    "dev"
    "doc"
    "man"
  ];

  /**
    Unpacking is handled in this package's constituent components
  */
  dontUnpack = true;
  /**
    Building is handled in this package's constituent components
  */
  dontBuild = true;

  /**
    `doCheck` controles whether tests are added as build gate for the combined package.
    This includes both the unit tests and the functional tests, but not the
    integration tests that run in CI (the flake's `hydraJobs` and some of the `checks`).
  */
  doCheck = true;

  /**
    `fixupPhase` currently doesn't understand that a symlink output isn't writable.

    We don't compile or link anything in this derivation, so fixups aren't needed.
  */
  dontFixup = true;

  checkInputs = [
    # Make sure the unit tests have passed
    nix-util-tests.tests.run
    nix-store-tests.tests.run
    nix-expr-tests.tests.run
    nix-fetchers-tests.tests.run
    nix-flake-tests.tests.run

    # Make sure the functional tests have passed
    nix-functional-tests
  ]
  ++
    lib.optionals (!stdenv.hostPlatform.isStatic && stdenv.buildPlatform.canExecute stdenv.hostPlatform)
      [
        # Perl currently fails in static build
        # TODO: Split out tests into a separate derivation?
        nix-perl-bindings
      ];

  nativeBuildInputs = [
    lndir
  ];

  installPhase =
    let
      devPaths = lib.mapAttrsToList (_k: lib.getDev) finalAttrs.finalPackage.libs;
    in
    ''
      mkdir -p $out $dev/nix-support

      # Custom files
      echo $libs >> $dev/nix-support/propagated-build-inputs
      echo ${nix-cli} ${lib.escapeShellArgs devPaths} >> $dev/nix-support/propagated-build-inputs

      # Merged outputs
      lndir ${nix-cli} $out

      for lib in ${lib.escapeShellArgs devPaths}; do
        lndir $lib $dev
      done

      # Forwarded outputs
      ln -sT ${nix-manual} $doc
      ln -sT ${nix-manual.man} $man
    '';

  passthru = {
    inherit (nix-cli) version;
    src = patchedSrc;

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

    /**
      Developer documentation for `nix`, in `share/doc/nix/{internal,external}-api/`.

      This is not a proper output; see `outputs` for context.
    */
    inherit devdoc;

    /**
      Extra tests that test this package, but do not run as part of the build.
      See <https://nixos.org/manual/nixpkgs/stable/index.html#var-passthru-tests>
    */
    tests = {
      pkg-config = testers.hasPkgConfigModules {
        package = finalAttrs.finalPackage;
      };
    };
  };

  meta = {
    mainProgram = "nix";
    description = "Nix package manager";
    longDescription = nix-cli.meta.longDescription;
    homepage = nix-cli.meta.homepage;
    license = nix-cli.meta.license;
    maintainers = maintainers;
    teams = teams;
    platforms = nix-cli.meta.platforms;
    outputsToInstall = [
      "out"
      "man"
    ];
    pkgConfigModules = [
      "nix-cmd"
      "nix-expr"
      "nix-expr-c"
      "nix-fetchers"
    ]
    ++ lib.optionals (lib.versionAtLeast version "2.29pre") [
      "nix-fetchers-c"
    ]
    ++ [
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

})
