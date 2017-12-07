{ stdenv, fetchurl, coreutils, python, duplicity, gawk, gnupg1, bash
, gnugrep, txt2man, makeWrapper, which
}:

stdenv.mkDerivation {
  name = "duply-1.9.2";

  src = fetchurl {
    url = "mirror://sourceforge/project/ftplicity/duply%20%28simple%20duplicity%29/1.9.x/duply_1.9.2.tgz";
    sha256 = "1ay50rsr90dcnjncjclzfckqmxxnizmi4jhb5rsybfn0xdj0kz1b";
  };

  buildInputs = [ txt2man makeWrapper ];

  postPatch = "patchShebangs .";

  installPhase = ''
    mkdir -p "$out/bin"
    mkdir -p "$out/share/man/man1"
    install -vD duply "$out/bin"
    wrapProgram "$out/bin/duply" --set PATH \
        ${stdenv.lib.makeBinPath [ coreutils python duplicity gawk gnupg1 bash gnugrep txt2man which ]}
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
