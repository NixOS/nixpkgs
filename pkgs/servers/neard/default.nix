{ stdenv, fetchgit, autoreconfHook, pkgconfig, systemd, glib, dbus, libnl, pythonPackages }:

stdenv.mkDerivation rec {
  name = "neard-0.15-post-git-20510929";

  src = fetchgit {
    url    = "https://git.kernel.org/pub/scm/network/nfc/neard.git";
    sha256 = "07dny1l8n46v0yn30zqa8bkyj8ay01xphc124nhf2sqwbff7nf2m";
  };

  buildInputs = [ autoreconfHook pkgconfig systemd glib dbus libnl pythonPackages.python pythonPackages.wrapPython ];
  pythonPath = [ pythonPackages.pygobject pythonPackages.dbus-python pythonPackages.pygtk ];

  configureFlags = [ "--disable-debug" "--enable-tools" "--enable-ese" "--with-systemdsystemunitdir=$out/lib/systemd/system" ];

  postInstall = ''
    install -m 0755 tools/snep-send $out/bin/

    install -D -m644 src/neard.service $out/lib/systemd/system/neard.service
    install -D -m644 src/main.conf $out/etc/neard/main.conf

    # INFO: the config option "--enable-test" would copy the apps to $out/lib/neard/test/ instead
    install -d $out/lib/neard
    install -m 0755 test/* $out/lib/neard/
    wrapPythonProgramsIn $out/lib/neard "$out $pythonPath"
  '';

  meta = with stdenv.lib; {
    description = "Near Field Communication manager";
    homepage    = https://01.org/linux-nfc;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ tstrobel ];
    platforms   = platforms.unix;
  };
}
