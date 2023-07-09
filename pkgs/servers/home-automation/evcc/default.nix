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
  version = "0.118.7";

  src = fetchFromGitHub {
    owner = "evcc-io";
    repo = pname;
    rev = version;
    hash = "sha256-1mE3PZDC3IikVvgHYK0RQ6gheGdZcwxwQRLo7f8h9F0=";
  };

  vendorHash = "sha256-1c+0EoTM/K0Bq0/eg4J/qNyslo7MP3VSwFgGn5DOWto=";

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-Kwt6YzaqJhEF90+r4+BjYwgmD5xXQBSEzwp6dg3X9GQ=";
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
