{ stdenv, fetchFromGitHub, makeWrapper, openssl, coreutils, gnugrep }:

stdenv.mkDerivation rec {
  name = "bash-supergenpass-unstable-${version}";
  version = "2012-11-02";

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "lanzz";
    repo = "bash-supergenpass";
    rev = "c84eaa22fb59ab6c390e7f2de7984513347e3a9a";
    sha256 = "0d3l55kdrf6arb98vwwz9ww55ing5w323fg7546v56hlq3hs5qc9";
  };

  installPhase = ''
    install -m755 -D supergenpass.sh "$out/bin/supergenpass"
    wrapProgram "$out/bin/supergenpass" --prefix PATH : "${stdenv.lib.makeBinPath [ openssl coreutils gnugrep ]}"
  '';

  meta = with stdenv.lib; {
    description = "Bash shell-script implementation of SuperGenPass password generation";
    longDescription = ''
      Bash shell-script implementation of SuperGenPass password generation
      Usage: ./supergenpass.sh <domain> [ <length> ]

      Default <length> is 10, which is also the original SuperGenPass default length.

      The <domain> parameter is also optional, but it does not make much sense to omit it.

      supergenpass will ask for your master password interactively, and it will not be displayed on your terminal.
    '';
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fgaz ];
    homepage = https://github.com/lanzz/bash-supergenpass;
  };
}

