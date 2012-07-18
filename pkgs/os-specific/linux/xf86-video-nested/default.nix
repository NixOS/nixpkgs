{ stdenv, fetchgit, autoconf, automake, fontsproto, libX11, libXext
, libtool, pkgconfig, renderproto, utilmacros, xorgserver
}:

stdenv.mkDerivation {
  name = "xf86-video-nested-2011-09-12";

  # Breaks at 8d80f2e415e9e58ca481fe52ae8f2290e25de898 for Xorg 7.6
  src = fetchgit {
    url = git://anongit.freedesktop.org/xorg/driver/xf86-video-nested;
    rev = "fceee1716625badf698ca27dd5788a4deb8533bc";
    sha256 = "6b3544ddcf40602364fd0e528f6e677c37ef8d08f6c4e756caea7e29abf200f7"; 
  };

  # Fixed in e123277d10337a1c3b853118df0d1becdddf3b77
  patchPhase = "sed -e 's/Werror/Werror -Wno-extra-portability/g' -i configure.ac";

  buildInputs = 
    [ autoconf automake fontsproto libX11 libXext libtool pkgconfig
      renderproto utilmacros xorgserver
    ];

  configureScript = "./autogen.sh";

  meta = {
    homepage = git://anongit.freedesktop.org/xorg/driver/xf86-video-nested;
    description = "driver to run Xorg on top of Xorg or something else";
    maintainers = [ stdenv.lib.maintainers.goibhniu ];
  };
}
