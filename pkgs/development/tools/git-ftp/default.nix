{ stdenv, fetchFromGitHub, pandoc, man }:
stdenv.mkDerivation rec {
  pname = "git-ftp";
  version = "1.6.0";
  src = fetchFromGitHub {
    owner = "git-ftp";
    repo = "git-ftp";
    rev = version;
    sha256 = "1hxkqf7jbrx24q18yxpnd3dxzh4xk6asymwkylp1x7zg6mcci87d";
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
