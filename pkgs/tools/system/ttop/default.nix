<<<<<<< HEAD
{ lib, nimPackages, fetchFromGitHub, testers }:

nimPackages.buildNimPackage (finalAttrs: {
  pname = "ttop";
  version = "1.2.5";
=======
{ lib, nimPackages, fetchFromGitHub }:

nimPackages.buildNimPackage rec {
  pname = "ttop";
  version = "1.0.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nimBinOnly = true;

  src = fetchFromGitHub {
    owner = "inv2004";
    repo = "ttop";
<<<<<<< HEAD
    rev = "v${finalAttrs.version}";
    hash = "sha256-GMGGkpBX+pmZ+TSDRs2N3H4Bwa3oXSDo9vM192js7Ww=";
  };

  buildInputs = with nimPackages; [ asciigraph illwill jsony parsetoml zippy ];

  nimFlags = [
    "-d:NimblePkgVersion=${finalAttrs.version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };
  };

  meta = with lib; {
    description = "Top-like system monitoring tool";
    homepage = "https://github.com/inv2004/ttop";
    changelog = "https://github.com/inv2004/ttop/releases/tag/${finalAttrs.src.rev}";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ figsoda sikmir ];
  };
})
=======
    rev = "v${version}";
    hash = "sha256-x4Uczksh6p3XX/IMrOFtBxIleVHdAPX9e8n32VAUTC4=";
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
