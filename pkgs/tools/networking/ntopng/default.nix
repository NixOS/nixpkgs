{ stdenv, fetchurl, libpcap, gnutls, libgcrypt, libxml2, glib, geoip, sqlite
, which, autoreconfHook, subversion, pkgconfig, groff
}:

# ntopng includes LuaJIT, mongoose, rrdtool and zeromq in its third-party/
# directory.

stdenv.mkDerivation rec {
  name = "ntopng-1.2.0_r8116";

  geoLiteCity = fetchurl {
    url = "http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz";
    sha256 = "1rv5yx5xgz04ymicx9pilidm19wh01ql2klwjcdakv558ndxdzd5";
  };

  geoLiteCityV6 = fetchurl {
    url = "http://geolite.maxmind.com/download/geoip/database/GeoLiteCityv6-beta/GeoLiteCityv6.dat.gz";
    sha256 = "0j974qpi92wwnibq46h16vxpcz7yy8bbqc4k8kmby1yx994k33v4";
  };

  geoIPASNum = fetchurl {
    url = "http://geolite.maxmind.com/download/geoip/database/asnum/GeoIPASNum.dat.gz";
    sha256 = "1msnbls66npq001nmf1wmkrh6vyacgi8g5phfm1c34cz7vqnh683";
  };

  geoIPASNumV6 = fetchurl {
    url = "http://geolite.maxmind.com/download/geoip/database/asnum/GeoIPASNumv6.dat.gz";
    sha256 = "126syia75mkxs6xfinfp70xcfq6a3rgfmh673pzzkwxya393lbdn";
  };

  src = fetchurl {
    url = "mirror://sourceforge/project/ntop/ntopng/${name}.tgz";
    sha256 = "0y7xc0l77k2qi2qalwfqiw2z361hdypirfv4k5gi652pb20jc9j6";
  };

  patches = [
    ./0001-Undo-weird-modification-of-data_dir.patch
    ./0002-Remove-requirement-to-have-writeable-callback-dir.patch
  ];

  buildInputs = [ libpcap gnutls libgcrypt libxml2 glib geoip sqlite which autoreconfHook subversion pkgconfig groff ];

  preConfigure = ''
    find . -name Makefile.in | xargs sed -i "s|/bin/rm|rm|"
  '';

  preBuild = ''
    sed -e "s|/usr/local|$out|g" \
        -i Ntop.cpp

    sed -e "s|\(#define CONST_DEFAULT_DATA_DIR\).*|\1 \"/var/lib/ntopng\"|g" \
        -e "s|\(#define CONST_DEFAULT_DOCS_DIR\).*|\1 \"$out/share/ntopng/httpdocs\"|g" \
        -e "s|\(#define CONST_DEFAULT_SCRIPTS_DIR\).*|\1 \"$out/share/ntopng/scripts\"|g" \
        -e "s|\(#define CONST_DEFAULT_CALLBACKS_DIR\).*|\1 \"$out/share/ntopng/scripts/callbacks\"|g" \
        -e "s|\(#define CONST_DEFAULT_INSTALL_DIR\).*|\1 \"$out/share/ntopng\"|g" \
        -i ntop_defines.h

    gunzip -c $geoLiteCity > httpdocs/geoip/GeoLiteCity.dat
    gunzip -c $geoLiteCityV6 > httpdocs/geoip/GeoLiteCityv6.dat
    gunzip -c $geoIPASNum > httpdocs/geoip/GeoIPASNum.dat
    gunzip -c $geoIPASNumV6 > httpdocs/geoip/GeoIPASNumv6.dat
  '';

  meta = with stdenv.lib; {
    description = "High-speed web-based traffic analysis and flow collection tool";
    homepage = http://www.ntop.org/products/ntop/;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
