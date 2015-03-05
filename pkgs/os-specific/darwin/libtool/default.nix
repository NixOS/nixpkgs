{ stdenv, cctools }:

stdenv.mkDerivation {
  name = "libtool-darwin-862";

  buildCommand = ''
    mkdir -p $out/bin
    ln -s ${cctools}/bin/libtool $out/bin/libtool
  '';
}