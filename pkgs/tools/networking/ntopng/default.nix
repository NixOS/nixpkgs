{ stdenv, fetchurl, libpcap, gnutls, libgcrypt, libxml2, glib, geoip, sqlite
, which, autoreconfHook, subversion, pkgconfig, groff
}:

# ntopng includes LuaJIT, mongoose, rrdtool and zeromq in its third-party/
# directory.

stdenv.mkDerivation rec {
  name = "ntopng-1.2.1";

  geoLiteCity = fetchurl {
    url = "http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz";
    sha256 = "13zfs1nzqwdb0dr4skx9hriajgx9wxsjhymd486d7np30vmbifan";
  };

  geoLiteCityV6 = fetchurl {
    url = "http://geolite.maxmind.com/download/geoip/database/GeoLiteCityv6-beta/GeoLiteCityv6.dat.gz";
    sha256 = "0j5dq06pjrh6d94wczsg6qdys4v164nvp2a7qqrg8w4knh94qp6n";
  };

  geoIPASNum = fetchurl {
    url = "http://geolite.maxmind.com/download/geoip/database/asnum/GeoIPASNum.dat.gz";
    sha256 = "16lfazhyhwmh8fyd7pxzwxp5sxszbqw4xdx3avv78hglhyb2ijkw";
  };

  geoIPASNumV6 = fetchurl {
    url = "http://geolite.maxmind.com/download/geoip/database/asnum/GeoIPASNumv6.dat.gz";
    sha256 = "16jd6f2pwy8616jb78x8j6zda7h0p1bp786y86rq3ipgcw6g0jgn";
  };

  src = fetchurl {
    urls = [
      "mirror://sourceforge/project/ntop/ntopng/old/${name}.tgz"
      "mirror://sourceforge/project/ntop/ntopng/${name}.tgz"
    ];
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
