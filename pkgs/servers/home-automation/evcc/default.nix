{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, fetchNpmDeps
, cacert
, git
, go
, enumer
, mockgen
, nodejs
, npmHooks
, nix-update-script
, nixosTests
}:

buildGoModule rec {
  pname = "evcc";
  version = "0.129.0";

  src = fetchFromGitHub {
    owner = "evcc-io";
    repo = "evcc";
    rev = version;
    hash = "sha256-LoDY6mVV2iDWUo1fUPrOjTTaQudkxrBTkCeIGQWSN8M=";
  };

  vendorHash = "sha256-AY1MXFgd6dK1w36iV0vur7ACGn5FTfPICEHXCnRfcb8=";

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-XG9nefBefF2gdDWA9IYBI2dv6Lig2LqGgOnTjyni0fM=";
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
      "TestTemplates/ac-elwa-2"
      "TestTemplates/allinpower"
      "TestTemplates/electricitymaps"
      "TestTemplates/elering"
      "TestTemplates/energinet"
      "TestTemplates/grünstromindex"
      "TestTemplates/keba-modbus"
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
