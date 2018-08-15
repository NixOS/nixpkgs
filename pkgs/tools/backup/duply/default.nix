{ stdenv, fetchurl, coreutils, python2, duplicity, gawk, gnupg1, bash
, gnugrep, txt2man, makeWrapper, which
}:

stdenv.mkDerivation rec {
  name = "duply-${version}";
  version = "2.1";

  src = fetchurl {
    url = "mirror://sourceforge/project/ftplicity/duply%20%28simple%20duplicity%29/2.1.x/duply_${version}.tgz";
    sha256 = "0i5j7h7h6ssrwhll0sfhymisshg54kx7j45zcqffzjxa0ylvzlm8";
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
      http://duplicity.nongnu.org/. It greatly simplifies it's usage by
      implementing backup job profiles, batch commands and more. Who says
      secure backups on non-trusted spaces are no child's play?
    '';
    homepage = http://duply.net/;
    license = licenses.gpl2;
    maintainers = [ maintainers.bjornfor ];
    platforms = stdenv.lib.platforms.unix;
  };
}
