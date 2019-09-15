{ stdenv, lib, buildGoPackage, fetchFromGitHub, fetchpatch }:

with lib;

buildGoPackage rec {
  pname = "certmgr";
  version = "2.0.1";

  goPackagePath = "github.com/cloudflare/certmgr/";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "certmgr";
    rev = "v${version}";
    sha256 = "03whd80q5dqhby5qi7d1l113cafhfc41lmhgw13bw952zjv3q209";
  };

  meta = {
    homepage = https://cfssl.org/;
    description = "Cloudflare's certificate manager";
    platforms = platforms.linux;
    license = licenses.bsd2;
    maintainers = with maintainers; [ johanot srhb offline ];
  };
}
