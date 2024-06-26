{
  lib,
  stdenv,
  fetchurl,
  ncurses,
  libpcap,
  cmake,
  openssl,
  git,
  lksctp-tools,
}:

stdenv.mkDerivation rec {
  version = "3.6.1";
  pname = "sipp";

  src = fetchurl {
    url = "https://github.com/SIPp/${pname}/releases/download/v${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-alYOg6/5gvMx3byt+zvVMMWJbNW3V91utoITPMhg7LE=";
  };

  postPatch = ''
    cp version.h src/version.h
  '';

  cmakeFlags = [
    "-DUSE_GSL=1"
    "-DUSE_PCAP=1"
    "-DUSE_SSL=1"
    "-DUSE_SCTP=${if stdenv.isLinux then "1" else "0"}"

    # file RPATH_CHANGE could not write new RPATH
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
  ];
  enableParallelBuilding = true;

  nativeBuildInputs = [
    cmake
    git
  ];
  buildInputs = [
    ncurses
    libpcap
    openssl
  ] ++ lib.optional (stdenv.isLinux) lksctp-tools;

  meta = with lib; {
    homepage = "http://sipp.sf.net";
    description = "SIPp testing tool";
    mainProgram = "sipp";
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}
