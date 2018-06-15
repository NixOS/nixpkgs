{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "gox-${version}";
  version = "0.4.0";

  goPackagePath = "github.com/mitchellh/gox";

  src = fetchFromGitHub {
    owner = "mitchellh";
    repo = "gox";
    rev = "v${version}";
    sha256 = "1q4fdkw904mrmh1q5z8pfd3r0gcn5dm776kldqawddy93iiwnp8r";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    homepage = https://github.com/mitchellh/gox;
    description = "A dead simple, no frills Go cross compile tool";
    platforms = platforms.all;
    license = licenses.mpl20;
  };

}
