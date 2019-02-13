{ stdenv, fetchurl, fetchpatch, gettext, libnl, ncurses, pciutils, pkgconfig, zlib }:

stdenv.mkDerivation rec {
  pname = "powertop";
  version = "2.10";

  src = fetchurl {
    url = "https://01.org/sites/default/files/downloads/${pname}-v${version}.tar.gz";
    sha256 = "0xaazqccyd42v2q532dxx40nqhb9sfsa6cyx8641rl57mfg4bdyk";
  };

  outputs = [ "out" "man" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gettext libnl ncurses pciutils zlib ];

  patches = stdenv.lib.optional stdenv.hostPlatform.isMusl (
    fetchpatch {
      name = "strerror_r.patch";
      url = "https://git.alpinelinux.org/cgit/aports/plain/main/powertop/strerror_r.patch?id=3b9214d436f1611f297b01f72469d66bfe729d6e";
      sha256 = "1kzddhcrb0n2iah4lhgxwwy4mkhq09ch25jjngyq6pdj6pmfkpfw";
    }
  );

  postPatch = ''
    substituteInPlace src/main.cpp --replace "/sbin/modprobe" "modprobe"
    substituteInPlace src/calibrate/calibrate.cpp --replace "/usr/bin/xset" "xset"
  '';

  meta = with stdenv.lib; {
    description = "Analyze power consumption on Intel-based laptops";
    homepage = https://01.org/powertop;
    license = licenses.gpl2;
    maintainers = with maintainers; [ chaoflow fpletz ];
    platforms = platforms.linux;
  };
}
