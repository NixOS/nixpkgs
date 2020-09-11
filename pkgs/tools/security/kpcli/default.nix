{ stdenv, fetchurl, makeWrapper, perl, perlPackages }:

stdenv.mkDerivation rec {
  version = "3.4";
  pname = "kpcli";

  src = fetchurl {
    url = "mirror://sourceforge/kpcli/${pname}-${version}.pl";
    sha256 = "0s46cni16ph93havmkrlai3k13mdppyca1s2bqm751a6rirmsgj0";
  };

  buildInputs = [ makeWrapper perl ];

  phases = [ "installPhase" "fixupPhase" ];

  installPhase = ''
    mkdir -p $out/{bin,share}
    cp ${src} $out/share/kpcli.pl
    chmod +x $out/share/kpcli.pl

    makeWrapper $out/share/kpcli.pl $out/bin/kpcli --set PERL5LIB \
      "${with perlPackages; makePerlPath ([
         CaptureTiny Clipboard Clone CryptRijndael SortNaturally TermReadKey TermShellUI FileKeePass TermReadLineGnu XMLParser
      ] ++ stdenv.lib.optional stdenv.isDarwin MacPasteboard)}"
  '';


  meta = with stdenv.lib; {
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
