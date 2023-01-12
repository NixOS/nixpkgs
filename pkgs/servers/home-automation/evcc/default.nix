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
  version = "0.111.1";

  src = fetchFromGitHub {
    owner = "evcc-io";
    repo = pname;
    rev = version;
    hash = "sha256-2ZxEUhDNF2E5http8Pz21L0tw6r4UOK5XYDXbHJDnEU=";
  };

  vendorHash = "sha256-+qne/eB+z8e0vStC9V0w7jgWgo3vvkaR42dUe+/eXDE=";

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-zrNfev2x5quuujifRHUufBK/GnR7QkCypHCyYb4nwkI=";
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
