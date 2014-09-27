{ stdenv, fetchurl, libpcap, gnutls, libgcrypt, libxml2, glib, geoip, sqlite
, which, autoreconfHook, subversion, pkgconfig, groff
}:

# ntopng includes LuaJIT, mongoose, rrdtool and zeromq in its third-party/
# directory.

stdenv.mkDerivation rec {
  name = "ntopng-1.2.1";

  geoLiteCity = fetchurl {
    url = "http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz";
    sha256 = "1sqskc8nh9k46nif4i6abjil9nfl4x6na4gadzbxp0929lbzyh0f";
  };

  geoLiteCityV6 = fetchurl {
    url = "http://geolite.maxmind.com/download/geoip/database/GeoLiteCityv6-beta/GeoLiteCityv6.dat.gz";
    sha256 = "1427zljjhbixjcihinj7l79v1daii7ikcmxgkmwdp4rbr25qxlhz";
  };

  geoIPASNum = fetchurl {
    url = "http://geolite.maxmind.com/download/geoip/database/asnum/GeoIPASNum.dat.gz";
    sha256 = "1rh2920sdciqn3pifl4rz0jl3m32ww4gjx495p5xd6ldpy95gn31";
  };

  geoIPASNumV6 = fetchurl {
    url = "http://geolite.maxmind.com/download/geoip/database/asnum/GeoIPASNumv6.dat.gz";
    sha256 = "1064arl40c80kwhbdylhwk6gn2xs36dr0aq3634i1rdpd4jm1a41";
  };

  src = fetchurl {
    url = "mirror://sourceforge/project/ntop/ntopng/${name}.tgz";
    sha256 = "1db83cd1v4ivl8hxzzdvvdcgk22ji7mwrfnd5nnwll6kb11i364v";
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
