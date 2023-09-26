{ lib
, buildGo121Module
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

buildGo121Module rec {
  pname = "evcc";
  version = "0.120.1";

  src = fetchFromGitHub {
    owner = "evcc-io";
    repo = pname;
    rev = version;
    hash = "sha256-mifpswB8hA7Ke2r2afYRlGDdhbz7AYxMZBNaRQvUodQ=";
  };

  vendorHash = "sha256-LNMNqlb/aj+ZHuwMvtK//oWyi34mm47ShAAD427szS4=";

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-quznAvgAFJJnKabsFZxAu7yDkAuvujg6of6En8JaFs4=";
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
    "test"
  ];

  ldflags = [
    "-X github.com/evcc-io/evcc/server.Version=${version}"
    "-X github.com/evcc-io/evcc/server.Commit=${src.rev}"
    "-s"
    "-w"
  ];

  preBuild = ''
    make ui
  '';

  doCheck = !stdenv.isDarwin; # tries to bind to local network, doesn't work in darwin sandbox

  preCheck = ''
    # requires network access
    rm meter/template_test.go
    rm charger/template_test.go
  '';

  passthru = {
    tests = {
      inherit (nixosTests) evcc;
    };
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "EV Charge Controller";
    homepage = "https://evcc.io";
    changelog = "https://github.com/andig/evcc/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
