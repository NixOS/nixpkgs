{ stdenv, fetchFromGitHub, pandoc, man }:
stdenv.mkDerivation rec {
  pname = "git-ftp";
  version = "1.5.2";
  src = fetchFromGitHub {
    owner = "git-ftp";
    repo = "git-ftp";
    rev = version;
    sha256 = "09qr8ciyfipcq32kl78ksvcra22aq7r4my685aajlbvkxgs0a867";
  };

  dontBuild = true;

  installPhase = ''
    make install-all prefix=$out
  '';

  buildInputs = [pandoc man];

  meta = with stdenv.lib; {
    description = "Git powered FTP client written as shell script.";
    homepage = https://git-ftp.github.io/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ tweber ];
    platforms = platforms.unix;
  };
}
