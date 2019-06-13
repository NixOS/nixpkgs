{stdenv, fetchurl, zlib, ncurses}:

stdenv.mkDerivation rec {
  version = "2.4.0";
  name = "atop-${version}";

  src = fetchurl {
    url = "https://www.atoptool.nl/download/atop-${version}.tar.gz";
    sha256 = "0s9xlxlzz688a80zxld840zkrmzw998rdkkg6yc7ssq8fw50275y";
  };

  buildInputs = [zlib ncurses];

  makeFlags = [
    ''SCRPATH=$out/etc/atop''
    ''LOGPATH=/var/log/atop''
    ''INIPATH=$out/etc/rc.d/init.d''
    ''CRNPATH=$out/etc/cron.d''
    ''ROTPATH=$out/etc/logrotate.d''
  ];

  preConfigure = ''
    sed -e "s@/usr/@$out/@g" -i $(find . -type f )
    sed -e "/mkdir.*LOGPATH/s@mkdir@echo missing dir @" -i Makefile
    sed -e "/touch.*LOGPATH/s@touch@echo should have created @" -i Makefile
    sed -e 's/chown/true/g' -i Makefile
    sed -e '/chkconfig/d' -i Makefile
    sed -e 's/chmod 04711/chmod 0711/g' -i Makefile
  '';

  preInstall = ''
    mkdir -p "$out"/{bin,sbin}
    make systemdinstall $makeFlags
  '';

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = with maintainers; [ raskin ];
    description = ''Console system performance monitor'';

    longDescription = ''
      Atop is an ASCII full-screen performance monitor that is capable of reporting the activity of all processes (even if processes have finished during the interval), daily logging of system and process activity for long-term analysis, highlighting overloaded system resources by using colors, etc. At regular intervals, it shows system-level activity related to the CPU, memory, swap, disks and network layers, and for every active process it shows the CPU utilization, memory growth, disk utilization, priority, username, state, and exit code.
    '';
    inherit version;
    license = licenses.gpl2;
    downloadPage = http://atoptool.nl/downloadatop.php;
  };
}
