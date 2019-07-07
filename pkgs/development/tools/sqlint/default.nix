{ lib, bundlerApp, fetchurl, ruby }:

let
  LIB_PG_QUERY_TAG = "10-1.0.1";
  libpgQuerySrc = fetchurl {
    name = "libpg_query.tar.gz";
    url = "https://codeload.github.com/lfittl/libpg_query/tar.gz/${LIB_PG_QUERY_TAG}";
    sha256 = "0m5jv134hgw2vcfkqlnw80fr3wmrdvgrvk1ndcx9s44bzi5nsp47";
  };
in bundlerApp {
  pname = "sqlint";
  gemdir = ./.;
  inherit ruby;

  exes = [ "sqlint" ];

  gemConfig = {
    pg_query = attrs: {
      dontBuild = false;
      postPatch = ''
        substituteInPlace ext/pg_query/extconf.rb \
          --replace "#{workdir}/libpg_query.tar.gz" "${libpgQuerySrc}"
      '';
    };
  };

  meta = with lib; {
    description = "Simple SQL linter";
    homepage    = https://github.com/purcell/sqlint;
    license     = licenses.mit;
    maintainers = with maintainers; [ ariutta ];
    platforms   = with platforms; [ "x86_64-linux" "x86_64-darwin" ];
  };
}
