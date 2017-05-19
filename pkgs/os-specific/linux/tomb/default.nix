{ stdenv, fetchurl, zsh, pinentry, cryptsetup, gnupg1orig, makeWrapper }:

let
    version = "2.4";
in

stdenv.mkDerivation rec {
  name = "tomb-${version}";

  src = fetchurl {
    url = "https://files.dyne.org/tomb/Tomb-${version}.tar.gz";
    sha256 = "1hv1w79as7swqj0n137vz8n8mwvcgwlvd91sdyssz41jarg7f1vr";
  };

  buildInputs = [ makeWrapper ];

  buildPhase = ''
    # manually patch the interpreter
    sed -i -e "1s|.*|#!${zsh}/bin/zsh|g" tomb
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1

    cp tomb $out/bin/tomb
    cp doc/tomb.1 $out/share/man/man1

    wrapProgram $out/bin/tomb \
        --prefix PATH : "${pinentry}/bin" \
        --prefix PATH : "${cryptsetup}/bin" \
        --prefix PATH : "${gnupg1orig}/bin"
  '';

  meta = {
    description = "File encryption on GNU/Linux";
    homepage = https://www.dyne.org/software/tomb/;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
  };
}
