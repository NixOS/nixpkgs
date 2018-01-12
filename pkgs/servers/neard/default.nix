{ stdenv, fetchurl, autoreconfHook, pkgconfig, systemd, glib, dbus, libnl, pythonPackages }:

stdenv.mkDerivation rec {
  name = "neard-0.16";

  src = fetchurl {
    url = "https://git.kernel.org/pub/scm/network/nfc/neard.git/snapshot/${name}.tar.gz";
    sha256 = "0bpdmyxvd3z54p95apz4bjb5jp8hbc04sicjapcryjwa8mh6pbil";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ systemd glib dbus libnl pythonPackages.python pythonPackages.wrapPython ];
  pythonPath = [ pythonPackages.pygobject2 pythonPackages.dbus-python pythonPackages.pygtk ];

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
