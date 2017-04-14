{ stdenv
, python3Packages
, fetchFromGitHub
, systemd }:

let
  python = python3Packages.python;
  wrapPython = python3Packages.wrapPython;
  date = "2017-01-22";
in
  stdenv.mkDerivation {
    name = "autorandr-unstable-${date}";

    buildInputs = [ python wrapPython ];

    phases = [ "unpackPhase" "installPhase" ];

    installPhase = ''
      make install TARGETS='autorandr' PREFIX=$out
      wrapPythonProgramsIn $out/bin/autorandr $out

      make install TARGETS='bash_completion' DESTDIR=$out

      make install TARGETS='autostart_config' PREFIX=$out DESTDIR=$out

      ${if false then ''
        # breaks systemd-udev-settle during boot so disabled
        make install TARGETS='systemd udev' PREFIX=$out DESTDIR=$out \
          SYSTEMD_UNIT_DIR=/lib/systemd/system \
          UDEV_RULES_DIR=/etc/udev/rules.d
        substituteInPlace $out/etc/udev/rules.d/40-monitor-hotplug.rules \
          --replace /bin "${systemd}/bin"
      '' else if systemd != null then ''
        make install TARGETS='systemd' PREFIX=$out DESTDIR=$out \
          SYSTEMD_UNIT_DIR=/lib/systemd/system
        make install TARGETS='udev' PREFIX=$out DESTDIR=$out \
          UDEV_RULES_DIR=/etc/udev/rules.d
      '' else ''
        make install TARGETS='pmutils' DESTDIR=$out \
          PM_SLEEPHOOKS_DIR=/lib/pm-utils/sleep.d
        make install TARGETS='udev' PREFIX=$out DESTDIR=$out \
          UDEV_RULES_DIR=/etc/udev/rules.d
      ''}
    '';

    src = fetchFromGitHub {
      owner = "phillipberndt";
      repo = "autorandr";
      rev = "855c18b7f2cfd364d6f085d4301b5b98ba6e572a";
      sha256 = "1yp1gns3lwa8796cb7par9czkc9i7paap2fkzf7wj6zqlkgjdvv0";
    };

    meta = {
      homepage = "http://github.com/phillipberndt/autorandr/";
      description = "Auto-detect the connect display hardware and load the appropiate X11 setup using xrandr";
      license = stdenv.lib.licenses.gpl3Plus;
      maintainers = [ stdenv.lib.maintainers.coroa ];
      platforms = stdenv.lib.platforms.unix;
    };
  }
