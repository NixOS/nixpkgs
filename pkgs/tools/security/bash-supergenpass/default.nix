{ stdenv, fetchFromGitHub, makeWrapper, openssl, coreutils, gnugrep }:

stdenv.mkDerivation {
  pname = "bash-supergenpass-unstable";
  version = "2018-04-18";

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "lanzz";
    repo = "bash-supergenpass";
    rev = "ece772b9ec095946ac4ea985cda5561b211e56f0";
    sha256 = "1gkbrycyyl7y3klbfx7xjvvfw5df1h4fj6x1f73gglfy6nk8ffnd";
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
    homepage = "https://github.com/lanzz/bash-supergenpass";
  };
}

