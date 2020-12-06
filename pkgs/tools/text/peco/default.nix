{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "peco";
  version = "0.5.3";

  goPackagePath = "github.com/peco/peco";
  subPackages = [ "cmd/peco" ];

  src = fetchFromGitHub {
    owner = "peco";
    repo = "peco";
    rev = "v${version}";
    sha256 = "1m3s1jrrhqccgg3frfnq6iprwwi97j13wksckpcyrg51z6y5q041";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "Simplistic interactive filtering tool";
    homepage = "https://github.com/peco/peco";
    license = licenses.mit;
    # peco should work on Windows or other POSIX platforms, but the go package
    # declares only linux and darwin.
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ pSub ];
  };
}
