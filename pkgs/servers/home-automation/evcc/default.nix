{ lib
, stdenv
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
}:

let
  buildGoModule = buildGo122Module;
  go = go_1_22;
in

buildGoModule rec {
  pname = "evcc";
  version = "0.126.4";

  src = fetchFromGitHub {
    owner = "evcc-io";
    repo = "evcc";
    rev = version;
    hash = "sha256-GDAj85zIrhu6XsY/XV1wKPtHNkj3bm3ooDcQaQeMHW0=";
  };

  vendorHash = "sha256-gfKJiZ7wSFWEEB/UCAbH18jdZdgG/58q3Yj0FQqMH8E=";

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-ghDLmsmcG+qDItiqaZy8MTYw/AU58bZfUzYY32XKNyk=";
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

  doCheck = !stdenv.isDarwin; # darwin sandbox limitations around network access, access to /etc/protocols and likely more

  checkFlags = let
    skippedTests = [
      # network access
      "TestOctopusConfigParse"
      "TestTemplates/allinpower"
      "TestTemplates/electricitymaps"
      "TestTemplates/elering"
      "TestTemplates/energinet"
      "TestTemplates/grünstromindex"
      "TestTemplates/pun"
      "TestTemplates/entsoe"
      "TestTemplates/ngeso"
      "TestTemplates/tibber"
      "TestTemplates/groupe-e"
      "TestTemplates/awattar"
      "TestTemplates/energy-charts-api"
      "TestTemplates/polestar"
      "TestTemplates/sma-inverter-speedwire/battery"
      "TestTemplates/sma-inverter-speedwire/pv"
      "TestTemplates/smartenergy"
      "TestTemplates/tibber-pulse/grid"

    ];
  in
  [ "-skip=^${lib.concatStringsSep "$|^" skippedTests}$" ];

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
