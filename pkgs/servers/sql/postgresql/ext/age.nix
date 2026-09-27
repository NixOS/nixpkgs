{
  bison,
  fetchFromGitHub,
  flex,
  lib,
  perl,
  postgresql,
  postgresqlBuildExtension,
  stdenv,
}:

let
  sources = {
    "18" = {
      version = "1.7.0-rc0";
      hash = "sha256-Hqjg62YLTLEa6wRA5S4MAIED7Hobtiih4E55cSzVTqE";
    };
    "17" = {
      version = "1.7.0-rc0";
      hash = "sha256-hAjhNj/benwZbbuxDl9RSjwWRai9CUozbEN6ecPKoFE=";
    };
    "16" = {
      version = "1.6.0-rc0";
      hash = "sha256-iukdi2c3CukGvjuTojybFFAZBlAw8GEfzFPr2qJuwTA=";
    };
    "15" = {
      version = "1.5.0-rc0";
      hash = "sha256-webZWgWZGnSoXwTpk816tjbtHV1UIlXkogpBDAEL4gM=";
    };
    "14" = {
      version = "1.6.0-rc0";
      hash = "sha256-6TTuqJs//QpNgNMw4TZf/3rdtMGSO/ytG4s8i+Jv2d8=";
    };
  };

  source =
    sources.${lib.versions.major postgresql.version} or {
      version = "";
      hash = throw "Source for Age is not available for ${postgresql.version}";
    };
in
postgresqlBuildExtension (finalAttrs: {
  pname = "age";
  inherit (source) version;

  src = fetchFromGitHub {
    owner = "apache";
    repo = "age";
    tag = "PG${lib.versions.major postgresql.version}/v${finalAttrs.version}";
    inherit (source) hash;
  };

  makeFlags = [
    "BISON=${bison}/bin/bison"
    "FLEX=${flex}/bin/flex"
    "PERL=${perl}/bin/perl"
  ];

  enableUpdateScript = false;
  passthru.tests = stdenv.mkDerivation {
    inherit (finalAttrs) version src;

    pname = "age-regression";

    dontConfigure = true;

    buildPhase =
      let
        postgresqlAge = postgresql.withPackages (_: [ finalAttrs.finalPackage ]);
      in
      ''
        # The regression tests need to be run in the order specified in the Makefile.
        echo -e "include Makefile\nfiles:\n\t@echo \$(REGRESS)" > Makefile.regress
        REGRESS_TESTS=$(make -f Makefile.regress files)

        ${lib.getDev postgresql}/lib/pgxs/src/test/regress/pg_regress \
          --inputdir=./ \
          --bindir='${postgresqlAge}/bin' \
          --encoding=UTF-8 \
          --load-extension=age \
          --inputdir=./regress --outputdir=./regress --temp-instance=./regress/instance \
          --port=61958 --dbname=contrib_regression \
          $REGRESS_TESTS
      '';

    installPhase = ''
      touch $out
    '';
  };

  meta = {
    broken = !builtins.elem (lib.versions.major postgresql.version) (builtins.attrNames sources);
    description = "Graph database extension for PostgreSQL";
    homepage = "https://age.apache.org/";
    changelog = "https://github.com/apache/age/raw/PG${lib.versions.major postgresql.version}/v${finalAttrs.version}/RELEASE";
    maintainers = with lib.maintainers; [ anish ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.asl20;
  };
})
