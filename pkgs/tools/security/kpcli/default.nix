{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  perl,
  perlPackages,
}:

stdenv.mkDerivation rec {
  version = "4.1";
  pname = "kpcli";

  src = fetchurl {
    url = "mirror://sourceforge/kpcli/${pname}-${version}.pl";
    sha256 = "sha256-3t8OhvRPj3oanFJKRaUVhGlF0B4E+UAlcfGMIpcet9s=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ perl ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/{bin,share}
    cp ${src} $out/share/kpcli.pl
    chmod +x $out/share/kpcli.pl

    makeWrapper $out/share/kpcli.pl $out/bin/kpcli --set PERL5LIB \
      "${
        with perlPackages;
        makePerlPath (
          [
            CaptureTiny
            Clipboard
            Clone
            CryptRijndael
            SortNaturally
            TermReadKey
            TermShellUI
            FileKeePass
            TermReadLineGnu
            XMLParser
          ]
          ++ lib.optional stdenv.isDarwin MacPasteboard
        )
      }"
  '';

  meta = with lib; {
    description = "KeePass Command Line Interface";
    mainProgram = "kpcli";
    longDescription = ''
      KeePass Command Line Interface (CLI) / interactive shell.
      Use this program to access and manage your KeePass 1.x or 2.x databases from a Unix-like command line.
    '';
    license = licenses.artistic1;
    homepage = "http://kpcli.sourceforge.net";
    platforms = platforms.all;
    maintainers = [ maintainers.j-keck ];
  };
}
