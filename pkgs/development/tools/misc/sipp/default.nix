{stdenv, fetchurl, ncurses, libpcap }:

stdenv.mkDerivation rec {

  version = "3.4-beta2";

  name = "sipp-${version}";

  src = fetchurl {
    url = "https://github.com/SIPp/sipp/archive/${version}.tar.gz";
    sha256 = "0rr3slarh5dhpinif5aqji9c9krnpvl7z49w7qahvsww1niawwdv";
  };

  configurePhase = ''
    export ac_cv_lib_curses_initscr=yes
    export ac_cv_lib_pthread_pthread_mutex_init=yes
    sed -i "s@pcap/\(.*\).pcap@$out/share/pcap/\1.pcap@g" src/scenario.cpp
    ./configure --prefix=$out --with-pcap
  '';

  postInstall = ''
    mkdir -pv $out/share/pcap
    cp pcap/* $out/share/pcap
  '';

  buildInputs = [ncurses libpcap];
}

