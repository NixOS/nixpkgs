{ lib, stdenv, fetchFromGitHub, pandoc, man }:
stdenv.mkDerivation rec {
  name = "git-ftp-${version}";
  version = "1.4.0";
  src = fetchFromGitHub {
    owner = "git-ftp";
    repo = "git-ftp";
    rev = version;
    sha256 = "0n8q1azamf10qql8f8c4ppbd3iisy460gwxx09v5d9hji5md27s3";
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
