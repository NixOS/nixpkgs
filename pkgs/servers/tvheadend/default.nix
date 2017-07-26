{avahi, cmake, dbus, fetchurl, gettext, git, gnutar, gzip, bzip2, ffmpeg, libiconv, openssl, pkgconfig, python
, stdenv, which, zlib}:

with stdenv.lib;

let version = "4.2.1";
    pkgName = "tvheadend";

in

stdenv.mkDerivation rec {
  name = "${pkgName}-${version}";

  src = fetchurl {
    url = "https://github.com/tvheadend/tvheadend/archive/v${version}.tar.gz";
    sha256 = "1wrj3w595c1hfl2vmfdmp5qncy5samqi7iisyq76jf3nlzgw6dvn";
  };

  enableParallelBuilding = true;

  # disable dvbscan, as having it enabled causes a network download which
  # cannot happen during build.
  configureFlags = [
    "--disable-dvbscan"
    "--disable-bintray_cache"
    "--disable-ffmpeg_static"
    "--disable-hdhomerun_client"
    "--disable-hdhomerun_static"
  ];

  buildPhase = "make";

  dontUseCmakeConfigure = true;

  buildInputs = [ avahi dbus cmake gettext git gnutar gzip bzip2 ffmpeg libiconv openssl pkgconfig python
    which zlib ];

  preConfigure = ''
    patchShebangs ./configure
    substituteInPlace src/config.c --replace /usr/bin/tar ${gnutar}/bin/tar
  '';

  meta = {
    description = "TV streaming server";
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
