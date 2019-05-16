{ stdenv, fetchFromGitHub, pandoc, man }:
stdenv.mkDerivation rec {
  name = "git-ftp-${version}";
  version = "1.5.1";
  src = fetchFromGitHub {
    owner = "git-ftp";
    repo = "git-ftp";
    rev = version;
    sha256 = "0nh2f58rwwfzmglm75fmmm10470a80q0vsihc2msa8xswngihg22";
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
