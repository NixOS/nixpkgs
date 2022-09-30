{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gopls";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "tools";
    rev = "gopls/v${version}";
    sha256 = "sha256-kDO7Sxz2pqZZBG2eGAWyh9UTAoYLzkAn86qh9LdepoU=";
  };

  modRoot = "gopls";
  vendorSha256 = "sha256-ny+gD3ZXp6ZncWJtpW9fprYojQBkIUL+FEKp/7K5rrU=";

  doCheck = false;

  # Only build gopls, and not the integration tests or documentation generator.
  subPackages = [ "." ];

  meta = with lib; {
    description = "Official language server for the Go language";
    homepage = "https://github.com/golang/tools/tree/master/gopls";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mic92 rski SuperSandro2000 zimbatm ];
  };
}
