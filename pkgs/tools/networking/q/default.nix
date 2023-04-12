{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "q";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "natesales";
    repo = "q";
    rev = "v${version}";
    sha256 = "sha256-kS3t4bAvxFoZBE5UMM5yJ0WbsN6MqkEYhkl8wiBJKQg=";
  };

  vendorHash = "sha256-jjhDD0qZh4QHjFO14+FsRFxEywByHB2gIxy/w3QOWBk=";

  doCheck = false; # tries to resolve DNS

  meta = {
    description = "A tiny and feature-rich command line DNS client with support for UDP, TCP, DoT, DoH, DoQ, and ODoH";
    homepage = "https://github.com/natesales/q";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.das_j ];
  };
}
