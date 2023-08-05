{ lib, buildGoModule, fetchFromGitHub, testers, vals }:

buildGoModule rec {
  pname = "vals";
  version = "0.26.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "variantdev";
    repo = pname;
    sha256 = "sha256-gICEqwt34pllvxA8JVc0rCQ2F3w6wT96eKTTxE0j398=";
  };

  vendorHash = "sha256-6DJiqDEgEHQbyIt4iShoBnagBvspd3W3vD56/FGjESs=";

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
