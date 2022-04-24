{ lib, stdenv, fetchurl, coreutils, python2, duplicity, gawk, gnupg, bash
, gnugrep, txt2man, makeWrapper, which
}:

stdenv.mkDerivation rec {
  pname = "duply";
  version = "2.3.1";

  src = fetchurl {
    url = "mirror://sourceforge/project/ftplicity/duply%20%28simple%20duplicity%29/2.3.x/duply_${version}.tgz";
    sha256 = "149hb9bk7hm5h3aqf19k37d0i2jf0viaqmpq2997i48qp3agji7h";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ txt2man ];

  postPatch = "patchShebangs .";

  installPhase = ''
    mkdir -p "$out/bin"
    mkdir -p "$out/share/man/man1"
    install -vD duply "$out/bin"
    wrapProgram "$out/bin/duply" --set PATH \
        ${lib.makeBinPath [ coreutils python2 duplicity gawk gnupg bash gnugrep txt2man which ]}
    "$out/bin/duply" txt2man > "$out/share/man/man1/duply.1"
  '';

  meta = with lib; {
    description = "Shell front end for the duplicity backup tool";
    longDescription = ''
      Duply is a shell front end for the duplicity backup tool
      https://www.nongnu.org/duplicity. It greatly simplifies its usage by
      implementing backup job profiles, batch commands and more. Who says
      secure backups on non-trusted spaces are no child's play?
    '';
    homepage = "https://duply.net/";
    license = licenses.gpl2;
    maintainers = [ maintainers.bjornfor ];
    platforms = lib.platforms.unix;
  };
}
