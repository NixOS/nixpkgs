{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "q";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "natesales";
    repo = "q";
    rev = "v${version}";
    sha256 = "sha256-M2TgDha+F4hY7f9sabzZEdsxdp8rdXDZB4ktmpDF5D8=";
  };

  vendorHash = "sha256-216NwRlU7mmr+ebiBwq9DVtFb2SpPgkGUrVZMUAY9rI=";

  doCheck = false; # tries to resolve DNS

  meta = {
    description = "A tiny and feature-rich command line DNS client with support for UDP, TCP, DoT, DoH, DoQ, and ODoH";
    homepage = "https://github.com/natesales/q";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.das_j ];
  };
}
