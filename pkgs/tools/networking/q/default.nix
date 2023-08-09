{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "q";
  version = "0.11.4";

  src = fetchFromGitHub {
    owner = "natesales";
    repo = "q";
    rev = "v${version}";
    sha256 = "sha256-zoIHpj1i0X5SCVhcT3bl5xxsDcvD2trEVhlIC5YnIZo=";
  };

  vendorHash = "sha256-cZRaf5Ks6Y4PzeVN0Lf1TxXzrifb7uQzsMbZf6JbLK4=";

  doCheck = false; # tries to resolve DNS

  meta = {
    description = "A tiny and feature-rich command line DNS client with support for UDP, TCP, DoT, DoH, DoQ, and ODoH";
    homepage = "https://github.com/natesales/q";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.das_j ];
  };
}
