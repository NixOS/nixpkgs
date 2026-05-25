# PostgreSQL's build system for extensions (PGXS) makes the following assumptions:
# - All extensions will be installed in the same prefix as PostgreSQL itself.
# - pg_config is able to return the correct paths for bindir/libdir/datadir etc.
#
# Both of those assumptions break with nix. Since each extension is a separate
# derivation, we need to put all its files into a different folder. At the same
# time, pg_config only points to the PostgreSQL derivation's paths.
#
# When building extensions, the paths provided by pg_config are used for two
# purposes:
# - To find postgres libs and headers and reference those paths via -L and -I flags.
# - To determine the correct install directory.
#
# The PGXS Makefiles also support an environment variable DESTDIR, which is added as
# a prefix to all install locations. This is primarily used for temporary installs
# while running the test suite. Since pg_config returns absolute paths to /nix/store
# for us, using DESTDIR will result in install locations of the form:
#   $DESTIDR/nix/store/<postgresql-output>/...
#
# In multiple iterations, the following approaches have been tried to work around all
# of this:
# 1. For a long time, all extensions in nixpkgs just overwrote the installPhase
#    and moved the respective files to the correct location manually. This approach
#    is not maintainable, because whenever upstream adds a new file, we'd have to
#    make sure the file is correctly installed as well. Additionally, it makes adding
#    a new extension harder than it should be.
#
# 2. A wrapper around pg_config could just replace the returned paths with paths to
#    $out of currently building derivation, i.e. the extension. This works for install-
#    ation, but breaks for any of the libs and headers the extension needs from postgres
#    itself.
#
# 3. A variation of 2., but make the pg_config wrapper only return the changed paths
#    during the installPahse. During configure and build, it would return the regular
#    paths to the PostgreSQL derivation. This works better, but not for every case.
#    Some extensions try to be smarter and search for the "postgres" binary to deduce
#    the necessary paths from that. Those would still need special handling.
#
# 4. Use the fact that DESTDIR is prepended to every installation directory - and only
#    there, to run a replacement of all Makefiles in postgres' lib/pgxs/ folder and
#    all Makefiles in the extension's source. "$DESTDIR/$bindir" can be replaced with
#    "$out/bin" etc. - thus mapping the installPhase directly into the right output.
#    This works beautifully - for the majority of cases. But it doesn't work for
#    some extensions that use CMake. And it doesn't work for some extensions that use
#    custom variables instead of the default "bindir" and friends.
#
# 5. Just set DESTDIR to the extensions's output and then clean up afterward. This will
#    result in paths like this:
#      /nix/store/<extension-output>/nix/store/<postgresql-output>/...
#    Directly after the installPhase, we'll move the files in the right folder.
#    This seems to work consistently across all extensions we have in nixpkgs right now.
#    Of course, it would break down for any extension that doesn't support DESTDIR -
#    but that just means PGXS is not used either, so that's OK.
#
# This last approach is the one we're taking in this file. To make sure the removal of the
# nested nix/store happens immediately after the installPhase, before any other postInstall
# hooks run, this needs to be run in an override of `mkDerivation` and not in a setup hook.

{
  lib,
  stdenv,
  postgresql,
  nix-update-script,
}:

lib.extendMkDerivation {
  constructDrv = stdenv.mkDerivation;

  excludeDrvArgNames = [
    "enableUpdateScript"
  ];

  extendDrvArgs =
    finalAttrs:
    {
      enableUpdateScript ? true,
      ...
    }@prevAttrs:
    {
      passthru =
        prevAttrs.passthru or { }
        // lib.optionalAttrs enableUpdateScript {
          updateScript =
            prevAttrs.passthru.updateScript or (nix-update-script (
              lib.optionalAttrs (lib.hasInfix "unstable" prevAttrs.version) {
                extraArgs = [ "--version=branch" ];
              }
            ));
        };

      strictDeps = true;
      buildInputs = [ postgresql ] ++ prevAttrs.buildInputs or [ ];
      nativeBuildInputs = [ postgresql.pg_config ] ++ prevAttrs.nativeBuildInputs or [ ];

      installFlags = [
        "DESTDIR=${placeholder "out"}"
      ]
      ++ prevAttrs.installFlags or [ ];

      postInstall = ''
        # DESTDIR + pg_config install the files into
        # /nix/store/<extension>/nix/store/<postgresql>/...
        # We'll now remove the /nix/store/<postgresql> part:
        if [[ -d "$out${postgresql}" ]]; then
            cp -alt "$out" "$out${postgresql}"/*
            rm -r "$out${postgresql}"
        fi

        if [[ -d "$out${postgresql.dev}" ]]; then
            mkdir -p "''${dev:-$out}"
            cp -alt "''${dev:-$out}" "$out${postgresql.dev}"/*
            rm -r "$out${postgresql.dev}"
        fi

        if [[ -d "$out${postgresql.lib}" ]]; then
            mkdir -p "''${lib:-$out}"
            cp -alt "''${lib:-$out}" "$out${postgresql.lib}"/*
            rm -r "$out${postgresql.lib}"
        fi

        if [[ -d "$out${postgresql.doc}" ]]; then
            mkdir -p "''${doc:-$out}"
            cp -alt "''${doc:-$out}" "$out${postgresql.doc}"/*
            rm -r "$out${postgresql.doc}"
        fi

        if [[ -d "$out${postgresql.man}" ]]; then
            mkdir -p "''${man:-$out}"
            cp -alt "''${man:-$out}" "$out${postgresql.man}"/*
            rm -r "$out${postgresql.man}"
        fi

        # In some cases (postgis) parts of the install script
        # actually work "OK", before we add DESTDIR, so some
        # files end up in
        # /nix/store/<extension>/nix/store/<extension>/...
        if [[ -d "$out$out" ]]; then
            cp -alt "$out" "$out$out"/*
            rm -r "$out$out"
        fi

        if [[ -d "$out/nix/store" ]]; then
            if ! rmdir "$out/nix/store" "$out/nix"; then
              find "$out/nix"
              nixErrorLog 'Found left-overs in $out/nix/store, make sure to move them into $out properly.'
              exit 1
            fi
        fi
      ''
      + prevAttrs.postInstall or "";
    };
}
