{stdenv, fetchFromGitHub, autoreconfHook, ncurses, libpcap }:

stdenv.mkDerivation rec {
  version = "3.5.1";

  name = "sipp-${version}";

  src = fetchFromGitHub {
    owner = "SIPp";
    repo = "sipp";
    rev = "v${version}";
    sha256 = "179a1fvqyk3jpxbi28l1xfw22cw9vgvxrn19w5f38w74x0jwqg5k";
  };

  patchPhase = ''
    sed -i "s@pcap/\(.*\).pcap@$out/share/pcap/\1.pcap@g" src/scenario.cpp
    sed -i -e "s|AC_CHECK_LIB(curses|AC_CHECK_LIB(ncurses|" configure.ac
    echo "#define SIPP_VERSION \"v${version}\"" > include/version.h
  '';

  configureFlags = [
    "--with-pcap"
  ];

  postInstall = ''
    mkdir -pv $out/share/pcap
    cp pcap/* $out/share/pcap
  '';

  buildInputs = [ncurses libpcap];

  nativeBuildInputs = [ autoreconfHook ];

  meta = with stdenv.lib; {
    homepage = http://sipp.sf.net;
    description = "The SIPp testing tool";
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}

