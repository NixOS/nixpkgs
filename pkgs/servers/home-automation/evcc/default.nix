{ lib
, buildGo122Module
, fetchFromGitHub
, fetchNpmDeps
, cacert
, go_1_22
, git
, enumer
, mockgen
, nodejs
, npmHooks
, nix-update-script
, nixosTests
, stdenv
}:

let
  buildGoModule = buildGo122Module;
  go = go_1_22;
in

buildGoModule rec {
  pname = "evcc";
  version = "0.124.10";

  src = fetchFromGitHub {
    owner = "evcc-io";
    repo = "evcc";
    rev = version;
    hash = "sha256-NbM8Uev2qIIS6WriP7QnVUumF29rZSOCavouPkPmYpE=";
  };

  vendorHash = "sha256-PZWMqv3R4Dq4cLtGNuvHCQ/GiYvlKJfSKEmBn0JYnb8=";

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-FWnRZ/NI49QZj8Uv6IbHc8IPAh3F5u4S6hY64B8+Uvk=";
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
    changelog = "https://github.com/evcc-io/evcc/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
