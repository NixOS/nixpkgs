{ lib
, buildGoModule
, fetchFromGitHub
, fetchNpmDeps
, cacert
, go
, git
, enumer
, mockgen
, nodejs
, npmHooks
, nix-update-script
, nixosTests
, stdenv
}:

buildGoModule rec {
  pname = "evcc";
  version = "0.110.1";

  src = fetchFromGitHub {
    owner = "evcc-io";
    repo = pname;
    rev = version;
    hash = "sha256-SIBVvVl1O+vqQug6LTzKEzFAay82ot4e+rXd17Djvqc=";
  };

  vendorHash = "sha256-YP6/3+jVbavBE6ZSopryC1SgQc5kzE+gWpNbwptBMG8=";

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-hc3IkWiafKBGtGPEPWWbj4XQsGh+PrGGnBV2bzEAn0s=";
  };

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
  ];

  overrideModAttrs = _: {
    nativeBuildInputs = [
      enumer
      go
      git
      cacert
      mockgen
    ];

    preBuild = ''
      make assets
    '';
  };

  tags = [
    "release"
  ];

  ldflags = [
    "-X github.com/evcc-io/evcc/server.Version=${version}"
    "-X github.com/evcc-io/evcc/server.Commit=${src.rev}"
    "-s"
    "-w"
  ];

  npmInstallFlags = [
    "--legacy-peer-deps"
  ];

  preBuild = ''
    make ui
  '';

  doCheck = !stdenv.isDarwin; # tries to bind to local network, doesn't work in darwin sandbox

  preCheck = ''
    # requires network access
    rm meter/template_test.go
  '';

  passthru = {
    tests = {
      inherit (nixosTests) evcc;
    };
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  meta = with lib; {
    description = "EV Charge Controller";
    homepage = "https://evcc.io";
    changelog = "https://github.com/andig/evcc/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
