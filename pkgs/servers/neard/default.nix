{ stdenv, fetchgit, autoreconfHook, pkgconfig, systemd, glib, dbus, libnl, pythonPackages }:

stdenv.mkDerivation rec {
  name = "neard-0.15-post-git-20510929";

  src = fetchgit {
    url    = "https://git.kernel.org/pub/scm/network/nfc/neard.git";
    sha256 = "08327b536ad8460a08bdceeec48c561e75ca56e5e0ee034c40d02cd1545906c0";
  };

  buildInputs = [ autoreconfHook pkgconfig systemd glib dbus libnl pythonPackages.python pythonPackages.wrapPython ];
  pythonPath = [ pythonPackages.pygobject pythonPackages.dbus pythonPackages.pygtk ];

  configureFlags = [ "--disable-debug" "--enable-tools" "--with-systemdsystemunitdir=$out/lib/systemd/system" ];

  postInstall = ''
    install -m 0755 tools/snep-send $out/bin/

    install -D -m644 src/neard.service $out/lib/systemd/system/neard.service
    install -D -m644 src/main.conf $out/etc/neard/main.conf

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
