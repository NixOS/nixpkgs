{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "cv-2014-07-20";

  src = fetchFromGitHub {
    owner = "Xfennec";
    repo = "cv";
    rev = "7441de974cc13f3b07903bb86c41be4e45c8e81b";
    sha256 = "19ky88b52a8zcv7lx802y4zi3sp0cdhya08cnax0yvlwwq43w6x9";
  };

  buildInputs = [ ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    homepage = https://github.com/Xfennec/cv;
    description = "Tool that shows the progress of coreutils programs";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
