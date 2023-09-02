{ lib, nimPackages, fetchFromGitHub }:

nimPackages.buildNimPackage (finalAttrs: {
  pname = "ttop";
  version = "1.2.0";
  nimBinOnly = true;

  src = fetchFromGitHub {
    owner = "inv2004";
    repo = "ttop";
    rev = "v${finalAttrs.version}";
    hash = "sha256-4Tjf4Qdpiu0ErH3dkff4cwYyw/8F8+VdFV9NZt8p/3o=";
  };

  buildInputs = with nimPackages; [ asciigraph illwill jsony parsetoml zippy ];

  meta = with lib;
    finalAttrs.src.meta // {
      description = "Top-like system monitoring tool";
      license = licenses.mit;
      platforms = platforms.linux;
      maintainers = with maintainers; [ sikmir ];
    };
})
