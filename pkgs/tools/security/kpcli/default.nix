{ stdenv, fetchurl, makeWrapper, perl, perlPackages }:

stdenv.mkDerivation rec {
  version = "3.0";
  name = "kpcli-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/kpcli/${name}.pl";
    sha256 = "1704b412f8h9cls85xcpqm9k4n5vga26r4xq9ghp4pr1hl27nywl";
  };

  buildInputs = [ makeWrapper perl ];

  phases = [ "installPhase" "fixupPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    cp ${src} $out/bin/kpcli
    chmod +x $out/bin/kpcli

    wrapProgram $out/bin/kpcli --set PERL5LIB \
      "${with perlPackages; stdenv.lib.makePerlPath [
         CaptureTiny Clipboard Clone CryptRijndael SortNaturally TermReadKey TermShellUI FileKeePass TermReadLineGnu XMLParser
      ]}"
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
