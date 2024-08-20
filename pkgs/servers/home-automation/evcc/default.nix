{ lib
, stdenv
, buildGo123Module
, fetchFromGitHub
, fetchNpmDeps
, cacert
, git
, go_1_23
, enumer
, mockgen
, nodejs
, npmHooks
, nix-update-script
, nixosTests
}:

buildGo123Module rec {
  pname = "evcc";
  version = "0.130.0";

  src = fetchFromGitHub {
    owner = "evcc-io";
    repo = "evcc";
    rev = version;
    hash = "sha256-+B2OQOf7BgYzJKvX9cu6SkIzfkD9z3Dk4pfVJmhTQzg=";
  };

  vendorHash = "sha256-Oj5+bmhlZHyOfcJf10EK8mvJauIWk88k0qj2NBkRvFQ=";

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-8DfLh6RhBI6GeTSIvmXCZ8Yudt5TYnimUoAdbOYfWfw=";
  };

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
  ];

  overrideModAttrs = _: {
    nativeBuildInputs = [
      enumer
      go_1_23
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
