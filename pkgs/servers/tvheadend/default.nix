{avahi, dbus, fetchurl, git, gzip, libav, libiconv, openssl, pkgconfig, python
, stdenv, which, zlib}:

let version = "4.0.4";
    pkgName = "tvheadend"; in

stdenv.mkDerivation rec {
  name = "${pkgName}-${version}";

  src = fetchurl {
    url = "https://github.com/tvheadend/tvheadend/archive/v${version}.tar.gz";
    sha256 = "acc5c852bccb32d6a281f523e78a1cceb4d41987fe015aba3f66e1898b02c168";
  };

  enableParallelBuilding = true;

  configureFlags = [ "--disable-dvbscan" ];

  buildInputs = [ avahi dbus git gzip libav libiconv openssl pkgconfig python
    which zlib ];

  preConfigure = "patchShebangs ./configure";

  meta = {
    description = "TV steaming server";
    longDescription = ''
	Tvheadend is a TV streaming server and recorder for Linux, FreeBSD and Android 
        supporting DVB-S, DVB-S2, DVB-C, DVB-T, ATSC, IPTV, SAT>IP and HDHomeRun as input sources.
	Tvheadend offers the HTTP (VLC, MPlayer), HTSP (Kodi, Movian) and SAT>IP streaming.'';
    homepage = "https://tvheadend.org";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.simonvandel ];
  };
}
