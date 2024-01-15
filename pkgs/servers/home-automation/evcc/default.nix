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
  version = "0.123.7";

  src = fetchFromGitHub {
    owner = "evcc-io";
    repo = "evcc";
    rev = version;
    hash = "sha256-I8qcKrCuiUpDdsWDMiEZdo+PBkMELo5V6GW+nKFaD3Y=";
  };

  patches = [
    (fetchpatch {
      # https://github.com/evcc-io/evcc/pull/11547
      name = "evcc-mockgen.patch";
      url = "https://github.com/evcc-io/evcc/commit/5ec02a9dba79a733f71fc02a9552eb01e4e08f0b.patch";
      hash = "sha256-uxKdtwdhUcMFCMkG756OD9aSMP9rdOL4Tg0HBWwp3kw=";
    })
  ];

  vendorHash = "sha256-FKF6+64mjrKgzFAb+O0QCURieOoRB//QNbpMFMcNG8s=";

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-a3AyqQ8GYP3g9KGbjtLHjHBrJGHg2sNjAQlMUa26pOY=";
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

    inherit patches;

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
