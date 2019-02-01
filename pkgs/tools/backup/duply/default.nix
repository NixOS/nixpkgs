{ stdenv, fetchurl, coreutils, python2, duplicity, gawk, gnupg1, bash
, gnugrep, txt2man, makeWrapper, which
}:

stdenv.mkDerivation rec {
  name = "duply-${version}";
  version = "2.2";

  src = fetchurl {
    url = "mirror://sourceforge/project/ftplicity/duply%20%28simple%20duplicity%29/2.2.x/duply_${version}.tgz";
    sha256 = "1bd7ivswxmxg64n0fnwgz6bkgckhdhz2qnnlkqqx4ccdxx15krbr";
  };

  buildInputs = [ txt2man makeWrapper ];

  postPatch = "patchShebangs .";

  installPhase = ''
    mkdir -p "$out/bin"
    mkdir -p "$out/share/man/man1"
    install -vD duply "$out/bin"
    wrapProgram "$out/bin/duply" --set PATH \
        ${stdenv.lib.makeBinPath [ coreutils python2 duplicity gawk gnupg1 bash gnugrep txt2man which ]}
    "$out/bin/duply" txt2man > "$out/share/man/man1/duply.1"
  '';

  meta = with stdenv.lib; {
    description = "Shell front end for the duplicity backup tool";
    longDescription = ''
      Duply is a shell front end for the duplicity backup tool
      https://www.nongnu.org/duplicity. It greatly simplifies its usage by
      implementing backup job profiles, batch commands and more. Who says
      secure backups on non-trusted spaces are no child's play?
    '';
    homepage = https://duply.net/;
    license = licenses.gpl2;
    maintainers = [ maintainers.bjornfor ];
    platforms = stdenv.lib.platforms.unix;
  };
}
