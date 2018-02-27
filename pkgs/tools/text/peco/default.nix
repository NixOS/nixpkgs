{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "peco-${version}";
  version = "0.5.2";

  goPackagePath = "github.com/peco/peco";
  subPackages = [ "cmd/peco" ];

  src = fetchFromGitHub {
    owner = "peco";
    repo = "peco";
    rev = "v${version}";
    sha256 = "0cgfwbnz4jp2nvmqf2i03xf69by8g0xgd3k5k9aj46y9hps1ka92";
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
