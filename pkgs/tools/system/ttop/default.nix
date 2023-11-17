{ lib, nimPackages, fetchFromGitHub, testers }:

nimPackages.buildNimPackage (finalAttrs: {
  pname = "ttop";
  version = "1.2.7";
  nimBinOnly = true;

  src = fetchFromGitHub {
    owner = "inv2004";
    repo = "ttop";
    rev = "v${finalAttrs.version}";
    hash = "sha256-oPdaUqh6eN1X5kAYVvevOndkB/xnQng9QVLX9bu5P5E=";
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
