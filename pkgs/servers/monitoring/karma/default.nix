{ lib
, buildGoModule
, fetchFromGitHub
, fetchNpmDeps
, nixosTests
, nodejs
, npmHooks
, testers
, karma
}:

buildGoModule rec {
  pname = "karma";
  version = "0.119";

  src = fetchFromGitHub {
    owner = "prymitive";
    repo = "karma";
    rev = "v${version}";
    hash = "sha256-7+N1+puypKptWf24tyhB/1s8xQpmuinIadj2leFJth8=";
  };

  vendorHash = "sha256-f1eaGTHMQGNyDec62Ddp1gx3l2kvOXYqZ4O/6dvsiAQ=";

  npmDeps = fetchNpmDeps {
    src = "${src}/ui";
    hash = "sha256-DHqb5XAdrpgGu8qST6s/F9tnEOApTXLe1MJuJMe7398=";
  };

  npmRoot = "ui";

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
  ];

  overrideModAttrs = oldAttrs: {
    nativeBuildInputs = lib.filter (drv: drv != npmHooks.npmConfigHook) oldAttrs.nativeBuildInputs;
  };

  postPatch = ''
    # Since we're using node2nix packages, the NODE_INSTALL hook isn't needed in the makefile
    sed -i \
      -e 's/$(NODE_INSTALL)//g' ./ui/Makefile \
      -e 's~NODE_PATH    := $(shell npm bin)~NODE_PATH    := ./node_modules~g' ./ui/Makefile \
      -e 's~NODE_MODULES := $(shell dirname `npm bin`)~NODE_MODULES := ./~g' ./ui/Makefile
  '';

  buildPhase = ''
    runHook preBuild

    VERSION="v${version}" make -j$NIX_BUILD_CORES

    runHook postBuild
  '';

  installPhase = ''
    install -Dm 755 ./karma $out/bin/karma
  '';

  passthru.tests = {
    karma = nixosTests.karma;
    version = testers.testVersion {
      version = "v${version}";
      package = karma;
      command = "karma --version";
    };
  };

  meta = with lib; {
    changelog = "https://github.com/prymitive/karma/blob/${src.rev}/CHANGELOG.md";
    description = "Alert dashboard for Prometheus Alertmanager";
    homepage = "https://karma-dashboard.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ nukaduka ];
    mainProgram = "karma";
  };
}
