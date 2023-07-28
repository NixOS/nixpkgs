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
  version = "0.114";

  src = fetchFromGitHub {
    owner = "prymitive";
    repo = "karma";
    rev = "v${version}";
    hash = "sha256-ZstBumK2ywwdr1ksMN7P8mHdYUiMOpfpYnvt0v0Io4w=";
  };

  vendorHash = "sha256-ZsXPA4KyKbc/bwkidyHNDg62mE8KlE+yIssOBZLmHVg=";

  npmDeps = fetchNpmDeps {
    src = "${src}/ui";
    hash = "sha256-gxsq+wwD+fUACkC07DWeVkvVtipZkEcPIR5RcPsPato=";
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
    description = "Alert dashboard for Prometheus Alertmanager";
    homepage = "https://karma-dashboard.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ nukaduka ];
  };
}
