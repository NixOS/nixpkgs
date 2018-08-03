{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  version = "1.6.1";
  name = "certmgr-${version}";

  goPackagePath = "github.com/cloudflare/certmgr/";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "certmgr";
    rev = "v${version}";
    sha256 = "1ky2pw1wxrb2fxfygg50h0mid5l023x6xz9zj5754a023d01qqr2";
  };

  meta = with stdenv.lib; {
    homepage = https://cfssl.org/;
    description = "Cloudflare's certificate manager";
    platforms = platforms.linux;
    license = licenses.bsd2;
    maintainers = with maintainers; [ johanot srhb ];
  };
}
