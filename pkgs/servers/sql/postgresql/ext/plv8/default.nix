{
  stdenv,
  lib,
  fetchFromGitHub,
  nodejs_20,
  perl,
  postgresql,
  jitSupport,
  buildPostgresqlExtension,
  # For test
  runCommand,
  coreutils,
  gnugrep,
}:

let
  libv8 = nodejs_20.libv8;
in
buildPostgresqlExtension (finalAttrs: {
  pname = "plv8";
  version = "3.2.3";

  src = fetchFromGitHub {
    owner = "plv8";
    repo = "plv8";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ivQZJSNn5giWF351fqZ7mBZoJkGtby5T7beK45g3Zqs=";
  };

  patches = [
    # Allow building with system v8.
    # https://github.com/plv8/plv8/pull/505 (rejected)
    ./0001-build-Allow-using-V8-from-system.patch
  ];

  nativeBuildInputs = [
    perl
  ];

  buildInputs = [
    libv8
  ];

  buildFlags = [ "all" ];

  makeFlags = [
    # Nixpkgs build a v8 monolith instead of separate v8_libplatform.
    "USE_SYSTEM_V8=1"
    "SHLIB_LINK=-lv8"
    "V8_OUTDIR=${libv8}/lib"
  ];

  # No configure script.
  dontConfigure = true;

  postPatch = ''
    patchShebangs ./generate_upgrade.sh
  '';

  passthru = {
    tests =
      let
        postgresqlWithSelf = postgresql.withPackages (_: [
          finalAttrs.finalPackage
        ]);
      in
      {
        smoke = runCommand "plv8-smoke-test" { } ''
          export PATH=${
            lib.makeBinPath [
              postgresqlWithSelf
              coreutils
              gnugrep
            ]
          }
          db="$PWD/testdb"
          initdb "$db"
          postgres -k "$db" -D "$db" &
          pid="$!"

          for i in $(seq 1 100); do
            if psql -h "$db" -d postgres -c "" 2>/dev/null; then
              break
            elif ! kill -0 "$pid"; then
              exit 1
            else
              sleep 0.1
            fi
          done

          psql -h "$db" -d postgres -c 'CREATE EXTENSION plv8; DO $$ plv8.elog(NOTICE, plv8.version); $$ LANGUAGE plv8;' 2> "$out"
          grep -q "${finalAttrs.version}" "$out"
          kill -0 "$pid"
        '';

        regression = stdenv.mkDerivation {
          name = "plv8-regression";
          inherit (finalAttrs)
            src
            patches
            nativeBuildInputs
            buildInputs
            dontConfigure
            ;

          buildPhase = ''
            runHook preBuild

            # The regression tests need to be run in the order specified in the Makefile.
            echo -e "include Makefile\nprint_regress_files:\n\t@echo \$(REGRESS)" > Makefile.regress
            REGRESS_TESTS=$(make -f Makefile.regress print_regress_files)

            ${lib.getDev postgresql}/lib/pgxs/src/test/regress/pg_regress \
              --bindir='${postgresqlWithSelf}/bin' \
              --temp-instance=regress-instance \
              --dbname=contrib_regression \
              $REGRESS_TESTS

            runHook postBuild
          '';

          installPhase = ''
            runHook preInstall

            touch "$out"

            runHook postInstall
          '';
        };
      };
  };

  meta = with lib; {
    description = "V8 Engine Javascript Procedural Language add-on for PostgreSQL";
    homepage = "https://plv8.github.io/";
    changelog = "https://github.com/plv8/plv8/blob/r${finalAttrs.version}/Changes";
    maintainers = [ ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    license = licenses.postgresql;
    broken = jitSupport;
  };
})
