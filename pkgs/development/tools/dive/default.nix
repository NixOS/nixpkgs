{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "dive";
  version = "0.6.0";

  goPackagePath = "github.com/wagoodman/dive";

  src = fetchFromGitHub {
    owner = "wagoodman";
    repo = "dive";
    rev = "v${version}";
    sha256 = "05n19a5q1yi8r6r72z634z93lz2i347zccs9qm7gx5h86nh147zd";
  };

  goDeps = ./deps.nix;

  doCheck = true;

  meta = with stdenv.lib; {
    description = "A tool for exploring each layer in a docker image";
    homepage = https://github.com/wagoodman/dive;
    license = licenses.mit;
    maintainers = with maintainers; [ marsam spacekookie ];
  };
}
