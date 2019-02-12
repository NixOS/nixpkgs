{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "dive";
  version = "0.5.0";

  goPackagePath = "github.com/wagoodman/dive";

  src = fetchFromGitHub {
    owner = "wagoodman";
    repo = "dive";
    rev = "v${version}";
    sha256 = "159m36p7b0ygdp42qdmmz02rhrkymh8m6yl21m1ixd4c2pjkjhns";
  };

  goDeps = ./deps.nix;

  doCheck = true;

  meta = with stdenv.lib; {
    description = "A tool for exploring each layer in a docker image";
    homepage = https://github.com/wagoodman/dive;
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
