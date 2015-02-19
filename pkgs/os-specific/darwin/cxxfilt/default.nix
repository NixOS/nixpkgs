{ stdenv, binutils_raw }:

stdenv.mkDerivation {
  name = "cxxfilt";
  buildCommand = ''
    mkdir -p $out/bin
    ln -s ${binutils_raw}/bin/c++filt $out/bin/c++filt
  '';
}