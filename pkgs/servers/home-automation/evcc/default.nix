{ lib
, buildGo120Module
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

buildGo120Module rec {
  pname = "evcc";
  version = "0.115.0";

  src = fetchFromGitHub {
    owner = "evcc-io";
    repo = pname;
    rev = version;
    hash = "sha256-vA2HpkzNuHulUUZKL6Wm2Y052v4JdC5V8hADq78rK5c=";
  };

  vendorHash = "sha256-/TqA2WTNJ3cSrqLgEly1KHGvMA/MQ+p364G0ne0ezfQ=";

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-LGlM+itulqtlwyVKfVGiZtTpcCmx+lVvE3JOFkYRHXk=";
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

  preBuild = ''
    make ui
  '';

  doCheck = !stdenv.isDarwin; # tries to bind to local network, doesn't work in darwin sandbox

  preCheck = ''
    # requires network access
    rm meter/template_test.go
    rm charger/template_test.go
    rm vehicle/template_test.go
    # times out (since 0.115.0, bisected to 31ab90e6381b30278731bd01effa62bdfb884ebc)
    rm util/templates/render_testing.go
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
