{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gopls";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "tools";
    rev = "gopls/v${version}";
    sha256 = "sha256-aaRaStQ35a/SK4YIR5rjvp8gPxvoNuhLh2AGbr0c6p4=";
  };

  modRoot = "gopls";
  vendorSha256 = "sha256-8+sWd48w+ghQzznobBPcCQMuc9HLgOuAZPwD6lbbfj8=";

  doCheck = false;

  # Only build gopls, and not the integration tests or documentation generator.
  subPackages = [ "." ];

  meta = with lib; {
    description = "Official language server for the Go language";
    homepage = "https://github.com/golang/tools/tree/master/gopls";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mic92 SuperSandro2000 zimbatm ];
  };
}
