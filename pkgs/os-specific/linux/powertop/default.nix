{ lib, stdenv, fetchFromGitHub, fetchpatch, gettext, libnl, ncurses, pciutils
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

  patches = [
    # Pull upstream patch for ncurses-6.3 compatibility
    (fetchpatch {
      name = "ncurses-6.3.patch";
      url = "https://github.com/fenrus75/powertop/commit/9ef1559a1582f23d599c149601c3a8e06809296c.patch";
      sha256 = "0qx69f3bwhxgsga9nas8lgrclf1rxvr7fq7fd2n8dv3x4lsb46j1";
    })
  ];

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
