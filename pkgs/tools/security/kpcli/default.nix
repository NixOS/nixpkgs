{ stdenv, fetchurl, makeWrapper, perl, perlPackages }:

stdenv.mkDerivation rec {
  version = "3.3";
  pname = "kpcli";

  src = fetchurl {
    url = "mirror://sourceforge/kpcli/${pname}-${version}.pl";
    sha256 = "1z6dy70d3ag16vgzzafcnxb8gap3wahfmy4vd22fpgbrdd6riph4";
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
    homepage = http://kpcli.sourceforge.net;
    platforms = platforms.all;
    maintainers = [ maintainers.j-keck ];
  };
}
