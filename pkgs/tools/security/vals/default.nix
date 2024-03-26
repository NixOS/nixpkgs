{ lib, buildGoModule, fetchFromGitHub, testers, vals }:

buildGoModule rec {
  pname = "vals";
  version = "0.35.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "variantdev";
    repo = pname;
    sha256 = "sha256-PH2R39bI357ND3Gf//Fe+xtMGVuqwggT9zZyy/OimmY=";
  };

  vendorHash = "sha256-oesPCwDZyJ1Q8LdyEnvAU5sdXFFHdxUP4jXltww8vuk=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  # Tests require connectivity to various backends.
  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = vals;
    command = "vals version";
  };

  meta = with lib; {
    description = "Helm-like configuration values loader with support for various sources";
    mainProgram = "vals";
    license = licenses.asl20;
    homepage = "https://github.com/variantdev/vals";
    changelog = "https://github.com/variantdev/vals/releases/v${version}";
    maintainers = with maintainers; [ stehessel ];
  };
}
