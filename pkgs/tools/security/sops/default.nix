{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "sops-${version}";
  version = "2.0.8";

  goPackagePath = "go.mozilla.org/sops";

  src = fetchFromGitHub {
    rev = version;
    owner = "mozilla";
    repo = "sops";
    sha256 = "0kawnp24i3r981hz6apfwhgp71002vjq7ir54arq0zkssmykms1c";
  };

  meta = with stdenv.lib; {
    description = "Mozilla sops (Secrets OPerationS) is an editor of encrypted files";
    homepage = https://github.com/mozilla/sops;
    license = licenses.mpl20;
  };
}
