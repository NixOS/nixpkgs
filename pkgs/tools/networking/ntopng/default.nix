{ stdenv, fetchurl, libpcap, gnutls, libgcrypt, libxml2, glib, geoip, sqlite
, which }:

# ntopng includes LuaJIT, mongoose, rrdtool and zeromq in its third-party/
# directory.

stdenv.mkDerivation rec {
  name = "ntopng-1.1_6932";

  src = fetchurl {
    url = "mirror://sourceforge/project/ntop/ntopng/${name}.tgz";
    sha256 = "0cdbmrsjp3bb7xzci0vfnnkmbyxwxbf47l4kbnk4ydd7xwhwdnzr";
  };

  patches = [
    ./0001-Undo-weird-modification-of-data_dir.patch
    ./0002-Remove-requirement-to-have-writeable-callback-dir.patch
  ];

  buildInputs = [ libpcap gnutls libgcrypt libxml2 glib geoip sqlite which ];

  preBuild = ''
    sed -e "s|^SHELL=.*|SHELL=${stdenv.shell}|" \
        -e "s|/usr/local|$out|g" \
        -e "s|/bin/rm|rm|g" \
        -i Makefile

    sed -e "s|^SHELL=.*|SHELL=${stdenv.shell}|" \
        -e "s|/usr/local|$out|g" \
        -e "s|/opt/local|/non-existing-dir|g" \
        -i configure

    sed -e "s|/usr/local|$out|g" \
        -i Ntop.cpp

    sed -e "s|\(#define CONST_DEFAULT_DATA_DIR\).*|\1 \"/var/lib/ntopng\"|g" \
        -e "s|\(#define CONST_DEFAULT_DOCS_DIR\).*|\1 \"$out/share/ntopng/httpdocs\"|g" \
        -e "s|\(#define CONST_DEFAULT_SCRIPTS_DIR\).*|\1 \"$out/share/ntopng/scripts\"|g" \
        -e "s|\(#define CONST_DEFAULT_CALLBACKS_DIR\).*|\1 \"$out/share/ntopng/scripts/callbacks\"|g" \
        -e "s|\(#define CONST_DEFAULT_INSTALL_DIR\).*|\1 \"$out/share/ntopng\"|g" \
        -i ntop_defines.h
  '';

  meta = with stdenv.lib; {
    description = "High-speed web-based traffic analysis and flow collection tool";
    homepage = http://www.ntop.org/products/ntop/;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
