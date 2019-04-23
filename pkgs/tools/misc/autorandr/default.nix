{ stdenv
, python3Packages
, fetchFromGitHub
, systemd
, xrandr }:

let
  python = python3Packages.python;
  version = "1.8.1";
in
  stdenv.mkDerivation {
    name = "autorandr-${version}";

    buildInputs = [ python ];

    # no wrapper, as autorandr --batch does os.environ.clear()
    buildPhase = ''
      substituteInPlace autorandr.py \
        --replace 'os.popen("xrandr' 'os.popen("${xrandr}/bin/xrandr' \
        --replace '["xrandr"]' '["${xrandr}/bin/xrandr"]'
    '';

    installPhase = ''
      runHook preInstall
      make install TARGETS='autorandr' PREFIX=$out

      make install TARGETS='bash_completion' DESTDIR=$out/share/bash-completion/completions

      make install TARGETS='autostart_config' PREFIX=$out DESTDIR=$out

      ${if systemd != null then ''
        make install TARGETS='systemd udev' PREFIX=$out DESTDIR=$out \
          SYSTEMD_UNIT_DIR=/lib/systemd/system \
          UDEV_RULES_DIR=/etc/udev/rules.d
        substituteInPlace $out/etc/udev/rules.d/40-monitor-hotplug.rules \
          --replace /bin/systemctl "${systemd}/bin/systemctl"
      '' else ''
        make install TARGETS='pmutils' DESTDIR=$out \
          PM_SLEEPHOOKS_DIR=/lib/pm-utils/sleep.d
        make install TARGETS='udev' PREFIX=$out DESTDIR=$out \
          UDEV_RULES_DIR=/etc/udev/rules.d
      ''}

      runHook postInstall
    '';

    src = fetchFromGitHub {
      owner = "phillipberndt";
      repo = "autorandr";
      rev = "${version}";
      sha256 = "1bp1cqkrpg77rjyh4lq1agc719fmxn92jkiicf6nbhfl8kf3l3vy";
    };

    meta = {
      homepage = https://github.com/phillipberndt/autorandr/;
      description = "Auto-detect the connect display hardware and load the appropiate X11 setup using xrandr";
      license = stdenv.lib.licenses.gpl3Plus;
      maintainers = [ stdenv.lib.maintainers.coroa ];
      platforms = stdenv.lib.platforms.unix;
    };
  }
