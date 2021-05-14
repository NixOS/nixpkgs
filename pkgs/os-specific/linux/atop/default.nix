{ lib
, stdenv
, fetchurl
, zlib
, ncurses
, findutils
, systemd
, python3
  # makes the package unfree via pynvml
, withAtopgpu ? false
}:

stdenv.mkDerivation rec {
  pname = "atop";
  version = "2.6.0";

  src = fetchurl {
    url = "https://www.atoptool.nl/download/atop-${version}.tar.gz";
    sha256 = "nsLKOlcWkvfvqglfmaUQZDK8txzCLNbElZfvBIEFj3I=";
  };

  nativeBuildInputs = if withAtopgpu then [ python3.pkgs.wrapPython ] else [ ];
  buildInputs = [ zlib ncurses ] ++ (if withAtopgpu then [ python3 ] else [ ]);
  pythonPath = if withAtopgpu then [ python3.pkgs.pynvml ] else [ ];

  makeFlags = [
    "DESTDIR=$(out)"
    "BINPATH=/bin"
    "SBINPATH=/bin"
    "MAN1PATH=/share/man/man1"
    "MAN5PATH=/share/man/man5"
    "MAN8PATH=/share/man/man8"
    "SYSDPATH=/lib/systemd/system"
    "PMPATHD=/lib/systemd/system-sleep"
  ];

  patches = [
    ./atop-pm.sh.patch
    ./atop-rotate.service.patch
    ./atop.service.patch
    ./atopacct.service.patch
  ] ++ (if withAtopgpu then [ ./atopgpu.service.patch ] else [ ]);

  preConfigure = ''
    for f in *.{sh,service}; do
      findutils=${findutils} systemd=${systemd} substituteAllInPlace "$f"
    done

    sed -e 's/chown/true/g' -i Makefile
    sed -e 's/chmod 04711/chmod 0711/g' -i Makefile
  '';

  installTargets = [ "systemdinstall" ];
  preInstall = ''
    mkdir -p $out/bin
  '';
  postInstall = ''
    # remove extra files we don't need
    rm -rf $out/{var,etc}
    rm -rf $out/bin/atop{sar,}-${version}
  '' + (if withAtopgpu then ''
    wrapPythonPrograms
  '' else ''
    rm $out/lib/systemd/system/atopgpu.service
    rm $out/bin/atopgpud
    rm $out/share/man/man8/atopgpud.8
  '');

  meta = with lib; {
    platforms = platforms.linux;
    maintainers = with maintainers; [ raskin ];
    description = "Console system performance monitor";

    longDescription = ''
      Atop is an ASCII full-screen performance monitor that is capable of reporting the activity of all processes (even if processes have finished during the interval), daily logging of system and process activity for long-term analysis, highlighting overloaded system resources by using colors, etc. At regular intervals, it shows system-level activity related to the CPU, memory, swap, disks and network layers, and for every active process it shows the CPU utilization, memory growth, disk utilization, priority, username, state, and exit code.
    '';
    inherit version;
    license = licenses.gpl2Plus;
    downloadPage = "http://atoptool.nl/downloadatop.php";
  };
}
