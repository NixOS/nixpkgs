{ stdenv, lib, fetchFromGitHub, automake, autoconf
, openssl, zlib, libpcap, boost
, useCairo ? false, cairo
}:

stdenv.mkDerivation rec {
  pname   = "tcpflow";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner  = "simsong";
    repo   = pname;
    rev    = "${pname}-${version}";
    sha256 = "063n3pfqa0lgzcwk4c0h01g2y5c3sli615j6a17dxpg95aw1zryy";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ automake autoconf ];
  buildInputs = [ openssl zlib libpcap boost ]
    ++ lib.optional useCairo cairo;

  prePatch = ''
    substituteInPlace bootstrap.sh \
      --replace ".git" "" \
      --replace "/bin/rm" "rm"
    substituteInPlace configure.ac \
      --replace "1.5.1" "1.5.2"
  '';

  preConfigure = "bash ./bootstrap.sh";

  meta = with stdenv.lib; {
    description = "TCP stream extractor";
    longDescription = ''
      tcpflow is a program that captures data transmitted as part of TCP
      connections (flows), and stores the data in a way that is convenient for
      protocol analysis and debugging.
    '';
    inherit (src.meta) homepage;
    license     = licenses.gpl3;
    maintainers = with maintainers; [ primeos raskin obadz ];
    platforms   = platforms.linux;
  };
}
