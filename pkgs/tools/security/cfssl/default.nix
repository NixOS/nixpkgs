{ stdenv, lib, buildGoPackage, fetchFromGitHub, pkgs }:

buildGoPackage rec {
  name = "cfssl-${version}";
  version = "20170527";

  goPackagePath = "github.com/cloudflare/cfssl";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "cfssl";
    rev = "114dc9691ec7bf3dac49d5953eccf7d91a0e0904";
    sha256 = "1ijq43mrzrf1gkgj5ssxq7sgy6sd4rl706dzqkq9krqv5f6kwhj1";
  };

  meta = with stdenv.lib; {
    homepage = https://cfssl.org/;
    description = "Cloudflare's PKI and TLS toolkit";
    platforms = platforms.linux;
    license = licenses.bsd2;
    maintainers = with maintainers; [ mbrgm ];
  };
}
