{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "sops-${version}";
  version = "3.0.2";

  goPackagePath = "go.mozilla.org/sops";

  src = fetchFromGitHub {
    rev = version;
    owner = "mozilla";
    repo = "sops";
    sha256 = "0zszlb35cmw9j9dg1bpcbwxwh094wcfxhas4ns58jp5n79rqwv9i";
  };

  meta = with stdenv.lib; {
    description = "Mozilla sops (Secrets OPerationS) is an editor of encrypted files";
    homepage = https://github.com/mozilla/sops;
    license = licenses.mpl20;
  };
}
