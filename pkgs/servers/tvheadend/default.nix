{avahi, dbus, fetchurl, git, gnutar, gzip, libav, libiconv, openssl, pkgconfig, python
, stdenv, which, zlib}:

with stdenv.lib;

let version = "4.0.7";
    pkgName = "tvheadend";

in

stdenv.mkDerivation rec {
  name = "${pkgName}-${version}";

  src = fetchurl {
    url = "https://github.com/tvheadend/tvheadend/archive/v${version}.tar.gz";
    sha256 = "0vhj4vkgl4brjw1pdc80g1wbjn6hyy57jrxkwilnivqfd1mwx3aw";
  };

  enableParallelBuilding = true;

  # disable dvbscan, as having it enabled causes a network download which
  # cannot happen during build.
  configureFlags = [ "--disable-dvbscan" ];

  buildInputs = [ avahi dbus git gnutar gzip libav libiconv openssl pkgconfig python
    which zlib ];

  preConfigure = ''
    patchShebangs ./configure
    substituteInPlace src/config.c --replace /usr/bin/tar ${gnutar}/bin/tar
  '';

  meta = {
    description = "TV steaming server";
    longDescription = ''
	Tvheadend is a TV streaming server and recorder for Linux, FreeBSD and Android 
        supporting DVB-S, DVB-S2, DVB-C, DVB-T, ATSC, IPTV, SAT>IP and HDHomeRun as input sources.
	Tvheadend offers the HTTP (VLC, MPlayer), HTSP (Kodi, Movian) and SAT>IP streaming.'';
    homepage = "https://tvheadend.org";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.simonvandel ];
  };
}
