{ lib, stdenv, fetchFromGitHub, gettext, libnl, ncurses, pciutils
, pkg-config, zlib, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "powertop";
  version = "2.14";

  src = fetchFromGitHub {
    owner = "fenrus75";
    repo = pname;
    rev = "v${version}";
    sha256 = "1zkr2y5nb1nr22nq8a3zli87iyfasfq6489p7h1k428pv8k45w4f";
  };

  outputs = [ "out" "man" ];

  nativeBuildInputs = [ pkg-config autoreconfHook ];
  buildInputs = [ gettext libnl ncurses pciutils zlib ];

  NIX_LDFLAGS = [ "-lpthread" ];

  postPatch = ''
    substituteInPlace src/main.cpp --replace "/sbin/modprobe" "modprobe"
    substituteInPlace src/calibrate/calibrate.cpp --replace "/usr/bin/xset" "xset"
    substituteInPlace src/tuning/bluetooth.cpp --replace "/usr/bin/hcitool" "hcitool"
  '';

  meta = with lib; {
    description = "Analyze power consumption on Intel-based laptops";
    homepage = "https://01.org/powertop";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ fpletz ];
    platforms = platforms.linux;
  };
}
