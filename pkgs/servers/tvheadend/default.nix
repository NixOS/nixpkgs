{ lib, stdenv, fetchFromGitHub, cmake, makeWrapper, pkg-config
, avahi, dbus, gettext, git, gnutar, gzip, bzip2, ffmpeg_4, libdvbcsa, libiconv, libopus, libvpx, openssl, python2
, v4l-utils, which, x264, x265, zlib }:

let
  versions = {
    tvheadend = {
      version = "4.2.8";
      rev = "v4.2.8";
      sha256 = "1xq059r2bplaa0nd0wkhw80jfwd962x0h5hgd7fz2yp6largw34m";
    };

    tvheadend-latest = {
      version = "master-9a51cea";
      rev = "9a51cea492e4a5579ca3ddf9233fecfa419de078";
      sha256 = "1n6da55i8jg90sf3x66xpzcialkwrf5b2hyllymwlv4g2wnr74av";
    };
  };
  common = pname: { version, rev, sha256 }:
    let
      dtv-scan-tables = stdenv.mkDerivation {
        pname = "dtv-scan-tables";
        version = "2022-03-14";
        src = fetchFromGitHub {
          owner = "tvheadend";
          repo = "dtv-scan-tables";
          rev = "1cbadfff235047ff255730da0cebeea225602461";
          sha256 = "11nlqpmp5vin3i8y30zniq3ysf4ny5gjbr2rwcjnyva5vxyjmzxv";
        };
        nativeBuildInputs = [ v4l-utils ];
        installFlags = [ "DATADIR=$(out)" ];
      };
    in

      stdenv.mkDerivation rec {
        pname = "tvheadend";
        inherit version;

        src = fetchFromGitHub {
          owner  = "tvheadend";
          repo   = "tvheadend";
          rev    = "v${rev}";
          sha256 = "${sha256}";
        };

        buildInputs = [
          avahi dbus gettext git gnutar gzip bzip2 ffmpeg_4 libdvbcsa libiconv libopus libvpx openssl python2
          which x264 x265 zlib
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
          maintainers = with maintainers; [ simonvandel melias122 ];
        };
      };
in
lib.mapAttrs common versions
