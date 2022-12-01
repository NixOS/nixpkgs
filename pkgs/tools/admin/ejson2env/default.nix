{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "ejson2env";
  version = "2.0.5";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-HcUmFajbOUZ0T5Th6OA9WBtfTz646qLbXx8NVeJsVng=";
  };

  vendorSha256 = "sha256-agWcD8vFNde1SCdkRovMNPf+1KODxV8wW1mXvE0w/CI=";

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
