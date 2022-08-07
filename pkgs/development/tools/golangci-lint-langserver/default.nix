{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "golangci-lint-langserver";
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "nametake";
    repo = "golangci-lint-langserver";
    rev = "v${version}";
    sha256 = "0x3qr2ckyk6rcn2rfm2sallzdprzxjh590gh3bfvqn7nb1mfw367";
  };

  vendorSha256 = "sha256-tAcl6P+cgqFX1eMYdS8vnfdNyb+1QNWwWdJsQU6Fpgg=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Language server for golangci-lint";
    homepage = "https://github.com/nametake/golangci-lint-langserver";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
