{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "q";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "natesales";
    repo = "q";
    rev = "v${version}";
    sha256 = "sha256-Esg2i8UNT+SuW9+jsnVEOt1ot822CamZ3JoR8ReY0+4=";
  };

  vendorHash = "sha256-oarXbxROTd7knHr9GKlrPnnS6ehkps2ZYYsUS9cn6ek=";

  doCheck = false; # tries to resolve DNS

  meta = {
    description = "A tiny and feature-rich command line DNS client with support for UDP, TCP, DoT, DoH, DoQ, and ODoH";
    homepage = "https://github.com/natesales/q";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.das_j ];
  };
}
