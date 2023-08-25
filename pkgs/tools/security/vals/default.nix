{ lib, buildGoModule, fetchFromGitHub, testers, vals }:

buildGoModule rec {
  pname = "vals";
  version = "0.27.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "variantdev";
    repo = pname;
    sha256 = "sha256-EYp+c3MbkdMIyo/2kHsKg9hjByqm6VdNxLcsl4dJrcg=";
  };

  vendorHash = "sha256-iNwQUwcF6iKYdqvy4t5xgOvNdhR+Vx+J5UHZzkNOed4=";

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
    license = licenses.asl20;
    homepage = "https://github.com/variantdev/vals";
    changelog = "https://github.com/variantdev/vals/releases/v${version}";
    maintainers = with maintainers; [ stehessel ];
  };
}
