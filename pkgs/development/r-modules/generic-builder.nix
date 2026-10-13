{
  stdenv,
  lib,
  R,
  xvfb-run,
  util-linux,
  libintl,
}:

attrs:

stdenv.mkDerivation (
  finalAttrs:
  {
    __structuredAttrs = true;
    strictDeps = true;

    name = "r-${attrs.name or "${attrs.pname}-${attrs.version}"}";

    requireX = false;

    nativeBuildInputs =
      (attrs.nativeBuildInputs or [ ])
      ++ [
        R
      ]
      ++ lib.optionals finalAttrs.requireX [
        util-linux
        xvfb-run
      ];

    buildInputs =
      (attrs.buildInputs or [ ])
      ++ lib.optionals stdenv.hostPlatform.isDarwin [
        libintl
      ];

    enableParallelBuilding = true;

    env =
      (attrs.env or { })
      // (lib.optionalAttrs (stdenv.hostPlatform.isDarwin) {
        NIX_CFLAGS_COMPILE = "${
          attrs.env.NIX_CFLAGS_COMPILE or ""
        } -I${lib.getInclude stdenv.cc.libcxx}/include/c++/v1";

      });

    configurePhase = ''
      runHook preConfigure

      export MAKEFLAGS+="''${enableParallelBuilding:+-j$NIX_BUILD_CORES}"
      export R_LIBS_SITE="$R_LIBS_SITE''${R_LIBS_SITE:+:}$out/library"

      if [ -f ./configure ] && [ -z "''${dontPatchShebangsInConfigure:-}" ]; then
        patchShebangs --build ./configure
      fi

      runHook postConfigure
    '';

    buildPhase = ''
      runHook preBuild
      runHook postBuild
    '';

    doCheck = true;

    checkPhase = ''
      # noop since R CMD INSTALL tests packages
    '';

    rCommand =
      if finalAttrs.requireX then
        # Unfortunately, xvfb-run has a race condition even with -a option, so that
        # we acquire a lock explicitly.
        "flock ${xvfb-run} xvfb-run -a -e xvfb-error R"
      else
        "R";

    installFlags = (attrs.installFlags or [ ]) ++ (lib.optional (!finalAttrs.doCheck) "--no-test-load");

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/library"

      # logic inside R CMD INSTALL essentially just expands `./configure $configureArgs` and runs it in a system shell
      # so we need to escape configureFlags if we want to support things like spaces in arguments
      local configureArgs=""
      if ((''${#configureFlags[@]})); then
        printf -v configureArgs '%q ' "''${configureFlags[@]}"
      fi

      $rCommand CMD INSTALL \
        --library="$out/library" \
        --built-timestamp='1970-01-01 00:00:00 UTC' \
        --configure-args="$configureArgs" \
        "''${installFlags[@]}" \
        .

      runHook postInstall
    '';

    stripDebugList = [
      "library/${attrs.pname}/libs"
      # Note: this is non-standard, but some packages do place binaries here via custom install logic (e.g. via install.libs.R)
      "library/${attrs.pname}/bin"
    ];

    postFixup = ''
      if test -e $out/nix-support/propagated-build-inputs; then
        ln -s $out/nix-support/propagated-build-inputs $out/nix-support/propagated-user-env-packages
      fi
    ''
    + (attrs.postFixup or "");
  }
  // (lib.removeAttrs attrs [
    # list of attrs that have custom logic for combining the default and the passed values
    # if not listed, the passed value will override the default value
    "name"
    "nativeBuildInputs"
    "buildInputs"
    "env"
    "installFlags"
    "postFixup"
  ])
)
