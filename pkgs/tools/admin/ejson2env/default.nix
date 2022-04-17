{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "ejson2env";
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Oc0fWihOUafYN5t9SxHxaYJEv5e46CCDNe4xo+Dcjrs=";
  };

  vendorSha256 = "sha256-BY45WirK9AVhvFGB5uqI4dLxzO2WuNNhhJbQ6nsRXao=";

  ldflags = [
    "-X main.version=${version}"
  ];

  meta = with lib; {
    description = "A tool to simplify storing secrets that should be accessible in the shell environment in your git repo.";
    homepage = "https://github.com/Shopify/ejson2env";
    maintainers = with maintainers; [ viraptor ];
    license = licenses.mit;
  };
}
