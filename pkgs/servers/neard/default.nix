{ stdenv, fetchgit, autoreconfHook, pkgconfig, systemd, glib, dbus, libnl }:

stdenv.mkDerivation rec {
  name = "neard-0.15-post-git-20510929";

  src = fetchgit {
    url    = "https://git.kernel.org/pub/scm/network/nfc/neard.git";
    sha256 = "08327b536ad8460a08bdceeec48c561e75ca56e5e0ee034c40d02cd1545906c0";
  };

  buildInputs = [ autoreconfHook pkgconfig systemd glib dbus libnl ];

  configureFlags = [ "--disable-debug" "--enable-tools" "--with-systemdsystemunitdir=$out/lib/systemd/system" ];

  postInstall = ''
    install -D -m644 src/neard.service $out/lib/systemd/system/neard.service
    install -D -m644 src/main.conf $out/etc/neard/main.conf
  '';

  meta = with stdenv.lib; {
    description = "Near Field Communication manager";
    homepage    = https://01.org/linux-nfc;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ tstrobel ];
    platforms   = platforms.unix;
  };
}
