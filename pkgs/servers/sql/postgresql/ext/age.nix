{ lib, stdenv, fetchFromGitHub, bison, flex, postgresql }:

stdenv.mkDerivation rec {
  pname = "age";
  version = "1.0.0-rc1";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "age";
    rev = "v${version}";
    sha256 = "sha256-b5cBpS5xWaohRZf5H0DwzNq0BodqWDjkAP44osPVYps=";
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
    # Only supports PostgreSQL 11 https://github.com/apache/age/issues/225
    broken = versions.major postgresql.version != "11";
    description = "A graph database extension for PostgreSQL";
    homepage = "https://age.apache.org/";
    changelog = "https://github.com/apache/age/raw/v${version}/RELEASE";
    maintainers = with maintainers; [ ];
    platforms = postgresql.meta.platforms;
    license = licenses.asl20;
  };
}
