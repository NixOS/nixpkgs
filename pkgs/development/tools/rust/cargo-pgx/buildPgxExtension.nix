# preBuildAndTest and some small other bits
# taken from https://github.com/tcdi/pgx/blob/v0.4.5/nix/extension.nix
# (but now heavily modified)
# which uses MIT License with the following license file
#
# MIT License
#
# Portions Copyright 2019-2021 ZomboDB, LLC.
# Portions Copyright 2021-2022 Technology Concepts & Design, Inc. <support@tcdi.com>.
# All rights reserved.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

{ lib
, cargo-pgx
, pkg-config
, rustPlatform
, stdenv
, Security
, writeShellScriptBin
}:

# The idea behind: Use it mostly like rustPlatform.buildRustPackage and so
# we hand most of the arguments down.
#
# Additional arguments are:
#   - `postgresql` postgresql package of the version of postgresql this extension should be build for.
#                  Needs to be the build platform variant.
#   - `useFakeRustfmt` Whether to use a noop fake command as rustfmt. cargo-pgx tries to call rustfmt.
#                      If the generated rust bindings aren't needed to use the extension, its a
#                      unnecessary and heavy dependency. If you set this to true, you also
#                      have to add `rustfmt` to `nativeBuildInputs`.

{ buildAndTestSubdir ? null
, buildType ? "release"
, buildFeatures ? [ ]
, cargoBuildFlags ? [ ]
, postgresql
# cargo-pgx calls rustfmt on generated bindings, this is not strictly necessary, so we avoid the
# dependency here. Set to false and provide rustfmt in nativeBuildInputs, if you need it, e.g.
# if you include the generated code in the output via postInstall.
, useFakeRustfmt ? true
, ...
} @ args:
let
  rustfmtInNativeBuildInputs = lib.lists.any (dep: lib.getName dep == "rustfmt") (args.nativeBuildInputs or []);
in

assert lib.asserts.assertMsg ((args.installPhase or "") == "")
  "buildPgxExtensions overwrites the installPhase, so providing one does nothing";
assert lib.asserts.assertMsg ((args.buildPhase or "") == "")
  "buildPgxExtensions overwrites the buildPhase, so providing one does nothing";
assert lib.asserts.assertMsg (useFakeRustfmt -> !rustfmtInNativeBuildInputs)
  "The parameter useFakeRustfmt is set to true, but rustfmt is included in nativeBuildInputs. Either set useFakeRustfmt to false or remove rustfmt from nativeBuildInputs.";
assert lib.asserts.assertMsg (!useFakeRustfmt -> rustfmtInNativeBuildInputs)
  "The parameter useFakeRustfmt is set to false, but rustfmt is not included in nativeBuildInputs. Either set useFakeRustfmt to true or add rustfmt from nativeBuildInputs.";

let
  fakeRustfmt = writeShellScriptBin "rustfmt" ''
    exit 0
    '';
  maybeDebugFlag = lib.optionalString (buildType != "release") "--debug";
  maybeEnterBuildAndTestSubdir = lib.optionalString (buildAndTestSubdir != null) ''
    export CARGO_TARGET_DIR="$(pwd)/target"
    pushd "${buildAndTestSubdir}"
  '';
  maybeLeaveBuildAndTestSubdir = lib.optionalString (buildAndTestSubdir != null) "popd";

  pgxPostgresMajor = lib.versions.major postgresql.version;
  preBuildAndTest = ''
    export PGX_HOME=$(mktemp -d)
    export PGDATA="$PGX_HOME/data-${pgxPostgresMajor}/"
    cargo-pgx pgx init "--pg${pgxPostgresMajor}" ${postgresql}/bin/pg_config
    echo "unix_socket_directories = '$(mktemp -d)'" > "$PGDATA/postgresql.conf"

    # This is primarily for Mac or other Nix systems that don't use the nixbld user.
    export USER="$(whoami)"
    pg_ctl start
    createuser -h localhost --superuser --createdb "$USER" || true
    pg_ctl stop
  '';

  argsForBuildRustPackage = builtins.removeAttrs args [ "postgresql" "useFakeRustfmt" ];

  # so we don't accidentally `(rustPlatform.buildRustPackage argsForBuildRustPackage) // { ... }` because
  # we forgot parentheses
  finalArgs = argsForBuildRustPackage // {
    buildInputs = (args.buildInputs or [ ]) ++ lib.optionals stdenv.isDarwin [ Security ];

    nativeBuildInputs = (args.nativeBuildInputs or [ ]) ++ [
      cargo-pgx
      postgresql
      pkg-config
      rustPlatform.bindgenHook
    ] ++ lib.optionals useFakeRustfmt [ fakeRustfmt ];

    buildPhase = ''
      runHook preBuild

      echo "Executing cargo-pgx buildPhase"
      ${preBuildAndTest}
      ${maybeEnterBuildAndTestSubdir}

      NIX_PGLIBDIR="${postgresql}/lib" \
      PGX_BUILD_FLAGS="--frozen -j $NIX_BUILD_CORES ${builtins.concatStringsSep " " cargoBuildFlags}" \
      cargo-pgx pgx package \
        --pg-config ${postgresql}/bin/pg_config \
        ${maybeDebugFlag} \
        --features "${builtins.concatStringsSep " " buildFeatures}" \
        --out-dir "$out"

      ${maybeLeaveBuildAndTestSubdir}

      runHook postBuild
    '';

    preCheck = preBuildAndTest + args.preCheck or "";

    installPhase = ''
      runHook preInstall

      echo "Executing buildPgxExtension install"

      ${maybeEnterBuildAndTestSubdir}

      cargo-pgx pgx stop all

      mv $out/${postgresql}/* $out
      rm -rf $out/nix

      ${maybeLeaveBuildAndTestSubdir}

      runHook postInstall
    '';

    PGX_PG_SYS_SKIP_BINDING_REWRITE = "1";
    CARGO_BUILD_INCREMENTAL = "false";
    RUST_BACKTRACE = "full";

    checkNoDefaultFeatures = true;
    checkFeatures = (args.checkFeatures or [ ]) ++ [ "pg_test pg${pgxPostgresMajor}" ];
  };
in
rustPlatform.buildRustPackage finalArgs
