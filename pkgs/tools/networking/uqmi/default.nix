{ stdenv, lib, fetchgit, cmake, perl, libubox, json_c }:

stdenv.mkDerivation {
  name = "uqmi-2016-12-19";

  src = fetchgit {
    url = "https://git.openwrt.org/project/uqmi.git";
    rev = "8ceeab690d8c6f1e3afbd4bcaee7bc2ba3fbe165";
    sha256 = "1fw9r36d024iiq6bq2cikaq5pams5pnbc4z6pcmcny2k4l5cdb6m";
  };

  postPatch = ''
    substituteInPlace data/gen-header.pl --replace /usr/bin/env ""
    patchShebangs .
  '';

  nativeBuildInputs = [ cmake perl ];
  buildInputs = [ libubox json_c ];

  meta = with lib; {
    description = "Tiny QMI command line utility";
    homepage = "https://git.openwrt.org/?p=project/uqmi.git;a=summary";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ fpletz ];
  };
}
