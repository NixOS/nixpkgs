{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "golangci-lint-langserver";
  version = "0.0.8";

  src = fetchFromGitHub {
    owner = "nametake";
    repo = "golangci-lint-langserver";
    rev = "v${version}";
    sha256 = "sha256-UdDWu3dZ/XUol2Y8lWk6d2zRZ+Pc1GiR6yqOuNaXxZY=";
  };

  vendorHash = "sha256-tAcl6P+cgqFX1eMYdS8vnfdNyb+1QNWwWdJsQU6Fpgg=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Language server for golangci-lint";
    homepage = "https://github.com/nametake/golangci-lint-langserver";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
