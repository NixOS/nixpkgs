{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "sops-${version}";
  version = "3.1.0";

  goPackagePath = "go.mozilla.org/sops";

  src = fetchFromGitHub {
    rev = version;
    owner = "mozilla";
    repo = "sops";
    sha256 = "02s85affgs2991p4akff68myx4h7m3jcly6xihv9g2knml7ixrkj";
  };

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Mozilla sops (Secrets OPerationS) is an editor of encrypted files";
    license = licenses.mpl20;
  };
}
