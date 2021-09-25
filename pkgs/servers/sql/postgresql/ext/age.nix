{ lib, stdenv, fetchFromGitHub, bison, flex, postgresql }:

stdenv.mkDerivation rec {
  pname = "age";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "bitnine-oss";
    repo = "AgensGraph-Extension";
    rev = "v${version}";
    sha256 = "0way59lj30727jlz2qz6rnw4fsxcd5028xcwgrwk7jxcaqi5fa17";
  };

  buildInputs = [ postgresql ];

  makeFlags = [
    "BISON=${bison}/bin/bison"
    "FLEX=${flex}/bin/flex"
  ];

  installPhase = ''
    install -D -t $out/lib *.so
    install -D -t $out/share/postgresql/extension *.sql
    install -D -t $out/share/postgresql/extension *.control
  '';

  passthru.tests = stdenv.mkDerivation {
    inherit version src;

    pname = "age-regression";

    dontConfigure = true;

    buildPhase = let
      postgresqlAge = postgresql.withPackages (ps: [ ps.age ]);
    in ''
      # The regression tests need to be run in the order specified in the Makefile.
      echo -e "include Makefile\nfiles:\n\t@echo \$(REGRESS)" > Makefile.regress
      REGRESS_TESTS=$(make -f Makefile.regress files)

      ${postgresql}/lib/pgxs/src/test/regress/pg_regress \
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

  meta = with lib; {
    description = "A graph database extension for PostgreSQL";
    homepage = "https://github.com/bitnine-oss/AgensGraph-Extension";
    changelog = "https://github.com/bitnine-oss/AgensGraph-Extension/releases/tag/v${version}";
    maintainers = with maintainers; [ ];
    platforms = postgresql.meta.platforms;
    license = licenses.asl20;
    broken = versionOlder postgresql.version "11.0";
  };
}
