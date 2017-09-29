{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "peco-${version}";
  version = "0.5.1";

  goPackagePath = "github.com/peco/peco";
  subPackages = [ "cmd/peco" ];

  src = fetchFromGitHub {
    owner = "peco";
    repo = "peco";
    rev = "v${version}";
    sha256 = "0jnlpr3nxx8xmjb6w4jlwshzz0p9hlww9919qbkm66afv16k0vm8";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "Simplistic interactive filtering tool";
    homepage = https://github.com/peco/peco;
    license = licenses.mit;
    # peco should work on Windows or other POSIX platforms, but the go package
    # declares only linux and darwin.
    platforms = platforms.linux ++ platforms.darwin;
  };
}
