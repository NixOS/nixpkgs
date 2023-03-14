{ lib, buildGoModule, fetchFromGitHub, testers, vals }:

buildGoModule rec {
  pname = "vals";
  version = "0.23.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "variantdev";
    repo = pname;
    sha256 = "sha256-YIzy8WPguIrhkg1HW2X714Xp9b+eL6bej/oXN62kyus=";
  };

  vendorHash = "sha256-CzfAUNKskEbxWmVGz/XHItUS9Mp12zjTJ3z9X7YBjR4=";

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
