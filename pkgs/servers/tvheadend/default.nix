{ stdenv, fetchFromGitHub, cmake, makeWrapper, pkgconfig
, avahi, dbus, gettext, git, gnutar, gzip, bzip2, ffmpeg, libiconv, openssl, python
, which, zlib }:

let
  version = "4.2.5";

in stdenv.mkDerivation rec {
  name = "tvheadend-${version}";

  src = fetchFromGitHub {
    owner  = "tvheadend";
    repo   = "tvheadend";
    rev    = "v${version}";
    sha256 = "199b0xm4lfdspmrirvzzg511yh358awciz23zmccvlvq86b548pz";
  };

  buildInputs = [
    avahi dbus gettext git gnutar gzip bzip2 ffmpeg libiconv openssl python
    which zlib
  ];

  nativeBuildInputs = [ cmake makeWrapper pkgconfig ];

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

  dontUseCmakeConfigure = true;

  preConfigure = ''
    patchShebangs ./configure

    substituteInPlace src/config.c \
      --replace /usr/bin/tar ${gnutar}/bin/tar

    # the version detection script `support/version` reads this file if it
    # exists, so let's just use that
    echo ${version} > rpm/version
  '';

  postInstall = ''
    wrapProgram $out/bin/tvheadend \
      --prefix PATH : ${stdenv.lib.makeBinPath [ bzip2 ]}
  '';

  meta = with stdenv.lib; {
    description = "TV streaming server";
    longDescription = ''
	Tvheadend is a TV streaming server and recorder for Linux, FreeBSD and Android
        supporting DVB-S, DVB-S2, DVB-C, DVB-T, ATSC, IPTV, SAT>IP and HDHomeRun as input sources.
	Tvheadend offers the HTTP (VLC, MPlayer), HTSP (Kodi, Movian) and SAT>IP streaming.'';
    homepage = https://tvheadend.org;
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ simonvandel ];
  };
}
