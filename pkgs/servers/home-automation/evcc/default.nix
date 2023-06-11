{ lib
, buildGoModule
, fetchFromGitHub
, fetchNpmDeps
, fetchpatch
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
  version = "0.118.0";

  src = fetchFromGitHub {
    owner = "evcc-io";
    repo = pname;
    rev = version;
    hash = "sha256-LQtFmN4IyDj/SRTik+ML3h1/tMwnTQ13dQHnghcDuUo=";
  };

  patches = [
    (fetchpatch {
      # fix ISO15118 vehicle setup
      url = "https://github.com/evcc-io/evcc/commit/cc22337b422e4ee541a2c75740c039f2d029bd9b.patch";
      hash = "sha256-Q+5Klpdv1cWVg716lbKl1JLwkr4LiLPRUoZHemFUQZc=";
    })
  ];

  vendorHash = "sha256-1YTVFn/DngzSQwYxGHCAaJl4ZnVj4au32YcpNo1m4w8=";

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-QRjOmanO+phyqgZb/cAyU0dFKI6T6o84MuObANZoYNE=";
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
