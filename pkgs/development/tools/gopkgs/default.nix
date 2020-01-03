{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "gopkgs";
  version = "2.0.1";

  goPackagePath = "github.com/uudashr/gopkgs";
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "uudashr";
    repo = "gopkgs";
    sha256 = "03zfwkmzwx2knkghky3irb2r78lbc1ccszjcg9y445b4pbqkn6w4";
  };

  meta = {
    description = "Tool to get list available Go packages.";
    homepage = https://github.com/uudashr/gopkgs;
    maintainers = with stdenv.lib.maintainers; [ vdemeester ];
    license = stdenv.lib.licenses.mit;
  };
}
