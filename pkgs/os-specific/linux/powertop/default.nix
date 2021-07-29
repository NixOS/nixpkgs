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

  outputs = [ "out" "man" ];

  nativeBuildInputs = [ pkg-config autoreconfHook ];
  buildInputs = [ gettext libnl ncurses pciutils zlib ];

  patches = lib.optional stdenv.hostPlatform.isMusl (
    fetchpatch {
      name = "strerror_r.patch";
      url = "https://git.alpinelinux.org/aports/plain/main/powertop/strerror_r.patch?id=3b9214d436f1611f297b01f72469d66bfe729d6e";
      sha256 = "1kzddhcrb0n2iah4lhgxwwy4mkhq09ch25jjngyq6pdj6pmfkpfw";
    }
  );

  NIX_LDFLAGS = [ "-lpthread" ];

  postPatch = ''
    substituteInPlace src/main.cpp --replace "/sbin/modprobe" "modprobe"
    substituteInPlace src/calibrate/calibrate.cpp --replace "/usr/bin/xset" "xset"
    substituteInPlace src/tuning/bluetooth.cpp --replace "/usr/bin/hcitool" "hcitool"
  '';

  meta = with lib; {
    description = "Analyze power consumption on Intel-based laptops";
    homepage = "https://01.org/powertop";
    license = licenses.gpl2;
    maintainers = with maintainers; [ fpletz ];
    platforms = platforms.linux;
  };
}
