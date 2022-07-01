{ lib, stdenv, fetchFromGitHub, bison, flex, postgresql }:

stdenv.mkDerivation rec {
  pname = "age";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "incubator-age";
    rev = "v${version}";
    sha256 = "1cl6p9qz2yhgm603ljlyjdn0msk3hzga1frjqsmqmpp3nw4dbkka";
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
    broken = true;
    description = "A graph database extension for PostgreSQL";
    homepage = "https://age.apache.org/";
    changelog = "https://github.com/apache/incubator-age/releases/tag/v${version}";
    maintainers = with maintainers; [ ];
    platforms = postgresql.meta.platforms;
    license = licenses.asl20;
  };
}
