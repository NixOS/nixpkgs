{ lib, buildGoModule, fetchFromGitHub, testers, vals }:

buildGoModule rec {
  pname = "vals";
  version = "0.33.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "variantdev";
    repo = pname;
    sha256 = "sha256-5+yaDcHqOt+bOdQIv4rDJuiR7acbkQvHJEfvc058+b8=";
  };

  vendorHash = "sha256-Lt6OPA6k+zXIahZR8F36YWruCtUsoQKb/LgzJ5NIcx8=";

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
