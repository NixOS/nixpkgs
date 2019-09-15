{ stdenv, buildGoPackage, fetchFromGitHub, fetchpatch }:

buildGoPackage rec {
  pname = "cfssl";
  version = "1.3.3";

  goPackagePath = "github.com/cloudflare/cfssl";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "cfssl";
    rev = version;
    sha256 = "1y61li4ray4gkzv8my3qy80038v2q7vk35m3vwbbkp8hyy8fk362";
  };

  meta = with stdenv.lib; {
    homepage = https://cfssl.org/;
    description = "Cloudflare's PKI and TLS toolkit";
    license = licenses.bsd2;
    maintainers = with maintainers; [ mbrgm ];
    platforms = platforms.all;
  };
}
