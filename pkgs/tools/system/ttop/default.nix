{ lib, nimPackages, fetchFromGitHub }:

nimPackages.buildNimPackage rec {
  pname = "ttop";
  version = "0.8.6";
  nimBinOnly = true;

  src = fetchFromGitHub {
    owner = "inv2004";
    repo = "ttop";
    rev = "v${version}";
    hash = "sha256-2TuDaStWRsO02l8WhYLWX7vqsC0ne2adxrzqrFF9BfQ=";
  };

  buildInputs = with nimPackages; [ asciigraph illwill parsetoml zippy ];

  meta = with lib;
    src.meta // {
      description = "Top-like system monitoring tool";
      license = licenses.mit;
      platforms = platforms.linux;
      maintainers = with maintainers; [ sikmir ];
    };
}
