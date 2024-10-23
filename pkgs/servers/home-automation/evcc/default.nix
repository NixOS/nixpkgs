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
  version = "0.131.0";

  src = fetchFromGitHub {
    owner = "evcc-io";
    repo = "evcc";
    rev = version;
    hash = "sha256-iR+qBRaDmk39wGigz734kS5hn/grX+ulZvytNYQW4bo=";
  };

  vendorHash = "sha256-T3SmFnGOw6AJaji4tR1uK+lQj8JNcUMJErUuhwdg3gA=";

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-RoCEvbn3sM1lLtrk+Kxi4vqYsqxJt79b0VZZgA8MQBA=";
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

  doCheck = !stdenv.hostPlatform.isDarwin; # darwin sandbox limitations around network access, access to /etc/protocols and likely more

  checkFlags = let
    skippedTests = [
      # network access
      "TestOctopusConfigParse"
      "TestTemplates"
      "TestOcpp"
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
