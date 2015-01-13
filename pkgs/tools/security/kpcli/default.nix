{ stdenv, fetchurl, makeWrapper, perl, perlPackages }:

stdenv.mkDerivation rec {
  version = "2.7";
  name = "kpcli-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/kpcli/${name}.pl";
    sha256 = "6bb1f7320b4474d6dbb73915393e5df96862f27c6228aa042a810fef46e2b777";
  };

  buildInputs = [ makeWrapper perl ];

  phases = [ "installPhase" "fixupPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    cp ${src} $out/bin/kpcli
    chmod +x $out/bin/kpcli

    wrapProgram $out/bin/kpcli --set PERL5LIB \
      "${with perlPackages; stdenv.lib.makePerlPath [
         Clone CryptRijndael SortNaturally TermReadKey TermShellUI FileKeePass TermReadLineGnu
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
