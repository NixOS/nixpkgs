{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "q";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "natesales";
    repo = "q";
    rev = "v${version}";
    sha256 = "sha256-WPVHMAau3+0jcIrRhRL5dy6h+J13LKj5GwQMJi7hGvo=";
  };

  vendorHash = "sha256-0Yd8y1SkxmfIFZuSheMGQnurlFv3sxkSDgGrQJLR3iU=";

  doCheck = false; # tries to resolve DNS

  meta = {
    description = "A tiny and feature-rich command line DNS client with support for UDP, TCP, DoT, DoH, DoQ, and ODoH";
    homepage = "https://github.com/natesales/q";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.das_j ];
  };
}
