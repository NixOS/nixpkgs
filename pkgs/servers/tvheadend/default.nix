{ lib, stdenv, fetchFromGitHub, cmake, makeWrapper, pkg-config
, avahi, dbus, gettext, git, gnutar, gzip, bzip2, ffmpeg_4, libiconv, openssl, python2
, v4l-utils, which, zlib }:

let
  version = "4.2.8";

  dtv-scan-tables = stdenv.mkDerivation {
    pname = "dtv-scan-tables";
    version = "2020-05-18";
    src = fetchFromGitHub {
      owner = "tvheadend";
      repo = "dtv-scan-tables";
      rev = "e3138a506a064f6dfd0639d69f383e8e576609da";
      sha256 = "19ac9ds3rfc2xrqcywsbd1iwcpv7vmql7gp01iikxkzcgm2g2b6w";
    };
    nativeBuildInputs = [ v4l-utils ];
    installFlags = [ "DATADIR=$(out)" ];
  };
in stdenv.mkDerivation {
  pname = "tvheadend";
  inherit version;

  src = fetchFromGitHub {
    owner  = "tvheadend";
    repo   = "tvheadend";
    rev    = "v${version}";
    sha256 = "1xq059r2bplaa0nd0wkhw80jfwd962x0h5hgd7fz2yp6largw34m";
  };

  buildInputs = [
    avahi dbus gettext git gnutar gzip bzip2 ffmpeg_4 libiconv openssl python2
    which zlib
  ];

  nativeBuildInputs = [ cmake makeWrapper pkg-config ];

  NIX_CFLAGS_COMPILE = [ "-Wno-error=format-truncation" "-Wno-error=stringop-truncation" ];

  # disable dvbscan, as having it enabled causes a network download which
  # cannot happen during build.  We now include the dtv-scan-tables ourselves
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

    substituteInPlace src/input/mpegts/scanfile.c \
      --replace /usr/share/dvb ${dtv-scan-tables}/dvbv5

    # the version detection script `support/version` reads this file if it
    # exists, so let's just use that
    echo ${version} > rpm/version
  '';

  postInstall = ''
    wrapProgram $out/bin/tvheadend \
      --prefix PATH : ${lib.makeBinPath [ bzip2 ]}
  '';

  meta = with lib; {
    description = "TV streaming server";
    longDescription = ''
        Tvheadend is a TV streaming server and recorder for Linux, FreeBSD and Android
        supporting DVB-S, DVB-S2, DVB-C, DVB-T, ATSC, IPTV, SAT>IP and HDHomeRun as input sources.
        Tvheadend offers the HTTP (VLC, MPlayer), HTSP (Kodi, Movian) and SAT>IP streaming.'';
    homepage = "https://tvheadend.org";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ simonvandel ];
  };
}
