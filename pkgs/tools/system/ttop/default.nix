{ lib, nimPackages, fetchFromGitHub }:

nimPackages.buildNimPackage (finalAttrs: {
  pname = "ttop";
  version = "1.0.1";
  nimBinOnly = true;

  src = fetchFromGitHub {
    owner = "inv2004";
    repo = "ttop";
    rev = "v${finalAttrs.version}";
    hash = "sha256-x4Uczksh6p3XX/IMrOFtBxIleVHdAPX9e8n32VAUTC4=";
  };

  buildInputs = with nimPackages; [ asciigraph illwill parsetoml zippy ];

  meta = with lib;
    finalAttrs.src.meta // {
      description = "Top-like system monitoring tool";
      license = licenses.mit;
      platforms = platforms.linux;
      maintainers = with maintainers; [ sikmir ];
    };
})
