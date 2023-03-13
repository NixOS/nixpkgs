{ lib
, stdenv
, fetchFromGitHub
, gettext
, libnl
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
  pname = "powertop";
  version = "2.15";

  src = fetchFromGitHub {
    owner = "fenrus75";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-53jfqt0dtMqMj3W3m6ravUTzApLQcljDHfdXejeZa4M=";
  };

  outputs = [ "out" "man" ];

  nativeBuildInputs = [ pkg-config autoreconfHook autoconf-archive ];
  buildInputs = [ gettext libnl ncurses pciutils zlib ];

  postPatch = ''
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
    changelog = "https://github.com/fenrus75/powertop/releases/tag/v${version}";
    description = "Analyze power consumption on Intel-based laptops";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ fpletz anthonyroussel ];
    platforms = platforms.linux;
  };
}
