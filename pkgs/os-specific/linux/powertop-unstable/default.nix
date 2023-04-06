{ lib
, stdenv
, fetchFromGitHub
, gettext
, libnl
, libtraceevent
, libtracefs
, ncurses
, pciutils
, pkg-config
, zlib
, autoreconfHook
, autoconf-archive
, nix-update-script
, testers
, powertop
}:

stdenv.mkDerivation rec {
  pname = "powertop-unstable";
  baseVersion = "2.15";
  version = "2023-04-03";

  src = fetchFromGitHub {
    owner = "fenrus75";
    repo = pname;
    rev = "b6d1569203f32ec1c2aaa065d05961c552a76a6f";
    hash = "sha256-JUqzyYyv2zi3UpuSnvjiJwecp9yYomlif6kla1wv7ZM=";
  };

  outputs = [ "out" "man" ];

  nativeBuildInputs = [ pkg-config autoreconfHook autoconf-archive ];
  buildInputs = [ gettext libnl libtraceevent libtracefs ncurses pciutils zlib ];

  postPatch = ''
    substituteInPlace configure.ac --replace "[powertop], [${baseVersion}]" "[powertop], [${version}]"
    substituteInPlace src/main.cpp --replace "/sbin/modprobe" "modprobe"
    substituteInPlace src/calibrate/calibrate.cpp --replace "/usr/bin/xset" "xset"
    substituteInPlace src/tuning/bluetooth.cpp --replace "/usr/bin/hcitool" "hcitool"
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = powertop;
      command = "powertop --version";
      inherit version;
    };
  };

  meta = with lib; {
    inherit (src.meta) homepage;
    changelog = "https://github.com/fenrus75/powertop/releases/tag/v${baseVersion}";
    description = "Analyze power consumption on Intel-based laptops";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ fpletz anthonyroussel hughobrien ];
    platforms = platforms.linux;
  };
}
