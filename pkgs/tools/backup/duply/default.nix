{ lib, stdenv, fetchurl, coreutils, python3, duplicity, gawk, gnupg, bash
, gnugrep, txt2man, makeWrapper, which
}:

stdenv.mkDerivation rec {
  pname = "duply";
  version = "2.4";

  src = fetchurl {
    url = "mirror://sourceforge/project/ftplicity/duply%20%28simple%20duplicity%29/2.4.x/duply_${version}.tgz";
    hash = "sha256-DCrp3o/ukzkfnVaLbIK84bmYnXvqKsvlkGn3GJY3iNg=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ txt2man ];

  postPatch = "patchShebangs .";

  installPhase = ''
    mkdir -p "$out/bin"
    mkdir -p "$out/share/man/man1"
    install -vD duply "$out/bin"
    wrapProgram "$out/bin/duply" --set PATH \
        ${lib.makeBinPath [ coreutils python3 duplicity gawk gnupg bash gnugrep txt2man which ]}
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
