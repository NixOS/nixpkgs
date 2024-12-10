{
  lib,
  stdenv,
  autoreconfHook,
  fetchurl,
  fetchpatch,
  ncurses,
}:

stdenv.mkDerivation rec {
  pname = "bwm-ng";
  version = "0.6.3";

  src = fetchurl {
    url = "https://www.gropp.org/bwm-ng/${pname}-${version}.tar.gz";
    sha256 = "0ikzyvnb73msm9n7ripg1dsw9av1i0c7q2hi2173xsj8zyv559f1";
  };

  patches = [
    # Pull upstream fix for ncurses-6.3 support.
    (fetchpatch {
      name = "ncurses-6.3.patch";
      url = "https://github.com/vgropp/bwm-ng/commit/6a2087db6cc7ac5b5f667fcd17c262c079e8dcf2.patch";
      sha256 = "1l5dii9d52v0x0sq458ybw7m9p8aan2vl94gwx5s8mgxsnbcmzzx";
      # accidentally committed changes
      excludes = [
        "config.h.in~"
        "configure.in"
        "configure~"
      ];
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    ncurses
  ];

  meta = with lib; {
    description = "A small and simple console-based live network and disk io bandwidth monitor";
    mainProgram = "bwm-ng";
    homepage = "http://www.gropp.org/?id=projects&sub=bwm-ng";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ];
    longDescription = ''
      bwm-ng supports:
       - /proc/net/dev, netstat, getifaddr, sysctl, kstat, /proc/diskstats /proc/partitions, IOKit,
         devstat and libstatgrab
       - unlimited number of interfaces/devices
       - interfaces/devices are added or removed dynamically from list
       - white-/blacklist of interfaces/devices
       - output of KB/s, Kb/s, packets, errors, average, max and total sum
       - output in curses, plain console, CSV or HTML
    '';
  };
}
