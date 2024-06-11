{ lib, stdenv, fetchurl, intltool, pkg-config, glib, polkit, cups, fetchpatch }:

stdenv.mkDerivation rec {
  version = "0.2.6";
  pname = "cups-pk-helper";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/cups-pk-helper/releases/cups-pk-helper-${version}.tar.xz";
    sha256 = "0a52jw6rm7lr5nbyksiia0rn7sasyb5cjqcb95z1wxm2yprgi6lm";
  };

  nativeBuildInputs = [ pkg-config intltool ];
  buildInputs = [ glib polkit cups ];

  patches = [
    # Don't use etc/dbus-1/system.d
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/cups-pk-helper/cups-pk-helper/merge_requests/2.patch";
      sha256 = "1kamhr5kn8c1y0q8xbip0fgr7maf3dyddlvab4n0iypk7rwwikl0";
    })
  ];

  meta = with lib; {
    description = "PolicyKit helper to configure cups with fine-grained privileges";
    homepage = "https://www.freedesktop.org/wiki/Software/cups-pk-helper/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
