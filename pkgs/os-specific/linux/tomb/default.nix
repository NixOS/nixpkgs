{ stdenv, fetchurl, zsh, pinentry, cryptsetup, gnupg1orig, makeWrapper }:

let
    version = "2.2";
in

stdenv.mkDerivation rec {
  name = "tomb-${version}";

  src = fetchurl {
    url = "https://files.dyne.org/tomb/tomb-${version}.tar.gz";
    sha256 = "11msj38fdmymiqcmwq1883kjqi5zr01ybdjj58rfjjrw4zw2w5y0";
  };

  buildInputs = [ makeWrapper ];

  buildPhase = ''
    # manually patch the interpreter
    sed -i -e "1s|.*|#!${zsh}/bin/zsh|g" tomb
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/man

    cp tomb $out/bin/tomb
    cp doc/tomb.1 $out/man.1

    wrapProgram $out/bin/tomb \
        --prefix PATH : "${pinentry}/bin" \
        --prefix PATH : "${cryptsetup}/bin" \
        --prefix PATH : "${gnupg1orig}/bin"
  '';

  meta = {
    description = "File encryption on GNU/Linux.";
    homepage = https://www.dyne.org/software/tomb/;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
  };
}
