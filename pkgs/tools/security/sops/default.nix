{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "sops-${version}";
  version = "3.2.0";

  goPackagePath = "go.mozilla.org/sops";

  src = fetchFromGitHub {
    rev = version;
    owner = "mozilla";
    repo = "sops";
    sha256 = "0lzwql3f4n70gmw1d0vnsg7hd0ma6ys0a4x54g3jk10nrn2f7wxl";
  };

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Mozilla sops (Secrets OPerationS) is an editor of encrypted files";
    license = licenses.mpl20;
  };
}
