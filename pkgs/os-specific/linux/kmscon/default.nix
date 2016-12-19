{ stdenv
, fetchurl
, libtsm
, systemd
, libxkbcommon
, libdrm
, mesa
, pango
, pixman
, pkgconfig
, docbook_xsl
, libxslt
}:

stdenv.mkDerivation rec {
  name = "kmscon-8";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/kmscon/releases/${name}.tar.xz";
    sha256 = "0axfwrp3c8f4gb67ap2sqnkn75idpiw09s35wwn6kgagvhf1rc0a";
  };

  buildInputs = [
    libtsm
    systemd
    libxkbcommon
    libdrm
    mesa
    pango
    pixman
    pkgconfig
    docbook_xsl
    libxslt
  ];

  # FIXME: Remove as soon as kmscon > 8 comes along.
  postPatch = ''
    sed -i -e 's/libsystemd-daemon libsystemd-login/libsystemd/g' configure
  '';

  configureFlags = [
    "--enable-multi-seat"
    "--disable-debug"
    "--enable-optimizations"
    "--with-renderers=bbulk,gltex,pixman"
  ];

  meta = {
    description = "KMS/DRM based System Console";
    homepage = "http://www.freedesktop.org/wiki/Software/kmscon/";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.linux;
  };
}
