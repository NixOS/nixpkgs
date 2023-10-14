{ lib, stdenv, bison, fetchFromGitHub, flex, perl, postgresql }:

let
  hashes = {
    "15" = "sha256-1vmwoflbU3++PFDcsLt9gyLkuzMRGNCD7vWl7/6Q+SE=";
    "14" = "sha256-w93Q499sZRk4q85A9yqKQjGUd9Pl8UL8K1D3W7mHRTU=";
    "13" = "sha256-Sot7FR0oW7kWA680pNCMCmlflu4RfJTSWZn9mrXrpzw=";
    "12" = "sha256-XezcXoHHLCD1/2OHmKhxome2pdjOsYAfZlpvOoU3aS4=";
    "11" = "sha256-ZkNAIMO69BxF3knQ+jcUBVuDgcoZXZccF5O+acpZ81M=";
  };
in
stdenv.mkDerivation rec {
  pname = "age";
  version = "1.4.0-rc0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "age";
    rev = "PG${lib.versions.major postgresql.version}/v${builtins.replaceStrings ["."] ["_"] version}";
    hash = hashes.${lib.versions.major postgresql.version} or (throw "Source for Age is not available for ${postgresql.version}");
  };

  buildInputs = [ postgresql ];

  makeFlags = [
    "BISON=${bison}/bin/bison"
    "FLEX=${flex}/bin/flex"
    "PERL=${perl}/bin/perl"
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
    broken = !builtins.elem (versions.major postgresql.version) (builtins.attrNames hashes);
    description = "A graph database extension for PostgreSQL";
    homepage = "https://age.apache.org/";
    changelog = "https://github.com/apache/age/raw/v${src.rev}/RELEASE";
    maintainers = with maintainers; [ ];
    platforms = postgresql.meta.platforms;
    license = licenses.asl20;
  };
}
