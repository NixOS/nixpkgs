{ lib, stdenv, fetchurl, makeWrapper, perl, perlPackages }:

stdenv.mkDerivation rec {
<<<<<<< HEAD
  version = "4.0";
=======
  version = "3.8.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "kpcli";

  src = fetchurl {
    url = "mirror://sourceforge/kpcli/${pname}-${version}.pl";
<<<<<<< HEAD
    sha256 = "sha256-UYnX2tad3Jg00kdX5WHStI6u2pyts+SZlgj/jv4o/TU=";
=======
    sha256 = "sha256-bIT4Y5JFeZv5stXOKXxBtdTsB4n39fqeh2dVaBbqRyw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ perl ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/{bin,share}
    cp ${src} $out/share/kpcli.pl
    chmod +x $out/share/kpcli.pl

    makeWrapper $out/share/kpcli.pl $out/bin/kpcli --set PERL5LIB \
      "${with perlPackages; makePerlPath ([
         CaptureTiny Clipboard Clone CryptRijndael SortNaturally TermReadKey TermShellUI FileKeePass TermReadLineGnu XMLParser
      ] ++ lib.optional stdenv.isDarwin MacPasteboard)}"
  '';


  meta = with lib; {
    description = "KeePass Command Line Interface";
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
