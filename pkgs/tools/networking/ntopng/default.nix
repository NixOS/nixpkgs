{ stdenv, fetchurl, libpcap, gnutls, libgcrypt, libxml2, glib
, geoip, geolite-legacy, sqlite, which, autoreconfHook, subversion
, pkgconfig, groff
}:

# ntopng includes LuaJIT, mongoose, rrdtool and zeromq in its third-party/
# directory.

stdenv.mkDerivation rec {
  name = "ntopng-1.2.1";

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

  buildInputs = [ libpcap gnutls libgcrypt libxml2 glib geoip geolite-legacy
    sqlite which autoreconfHook subversion pkgconfig groff ];

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

    rmdir httpdocs/geoip
    ln -s ${geolite-legacy}/share/GeoIP httpdocs/geoip
  '';

  meta = with stdenv.lib; {
    description = "High-speed web-based traffic analysis and flow collection tool";
    homepage = http://www.ntop.org/products/ntop/;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
