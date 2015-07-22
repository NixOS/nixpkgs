{ stdenv, fetchgit, libX11, libXtst, pkgconfig, inputproto, libXi, xproto, xextproto }:

stdenv.mkDerivation rec {
  name = "ksuperkey-git-2015-07-21";

  buildInputs = [
    libX11 libXtst pkgconfig inputproto libXi xproto xextproto
  ];

  src = fetchgit {
    url = "https://github.com/hanschen/ksuperkey";
    rev = "e75a31a0e3e80b14341e92799a7ce3232ac37639";
    sha256 = "00be6b93daf78bae0223f002e782e30a650dded3c5a83b1adfe9439e20e398fb";
  };

  preConfigure = ''
    makeFlags="$makeFlags PREFIX=$out"
  '';

  meta = {
    description = "A tool to be able to bind the super key as a key rather than a modifier";
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.vozz ];
    platforms = stdenv.lib.platforms.linux;
  };
}
