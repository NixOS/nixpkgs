{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, fetchNpmDeps
, nixosTests
, nodejs
, npmHooks
}:

buildGoModule rec {
  pname = "karma";
  version = "0.115";

  src = fetchFromGitHub {
    owner = "prymitive";
    repo = "karma";
    rev = "v${version}";
    hash = "sha256-SW/nmJcSk/LmoKLuD5stsSaRGaJctl6hVSODNCT9i64=";
  };

  vendorHash = "sha256-Y55AaB8KRV+Tq/Trg1BOOwziyt+yJ2b3iVYA6bDebQY=";

  npmDeps = fetchNpmDeps {
    src = "${src}/ui";
    hash = "sha256-/L+eU0xwaopL2im9epiZiZ23dUqJ+3OwhWw/rIZC6hI=";
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

  passthru.tests.karma = nixosTests.karma;

  meta = with lib; {
    changelog = "https://github.com/prymitive/karma/blob/${src.rev}/CHANGELOG.md";
    description = "Alert dashboard for Prometheus Alertmanager";
    homepage = "https://karma-dashboard.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ nukaduka ];
  };
}
