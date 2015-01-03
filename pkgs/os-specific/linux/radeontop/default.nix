{ stdenv, fetchurl, substituteAll, pkgconfig
, gettext, ncurses, libdrm, libpciaccess }:

stdenv.mkDerivation rec {
  name = "radeontop-${version}";
  version = "0.8";

  src = fetchurl {
    url = "https://github.com/clbr/radeontop/archive/v${version}.tar.gz";
    sha256 = "12c4kpr9zy2a21k8mck9cbfwm54x1l0i96va97m70pc9ramf2c24";
  };

  buildInputs = [ pkgconfig gettext ncurses libdrm libpciaccess ];

  patches = [
    ./install-paths.patch

    # The default generation of version.h expects a git clone.
    (substituteAll {
      src = ./version-header.patch;
      inherit version;
    })
  ];

  postPatch = ''
    substituteInPlace radeontop.c \
      --replace /usr/share/locale $out/share/locale
  '';

  makeFlags = "DESTDIR=$(out)";

  meta = with stdenv.lib; {
    description = "Top-like tool for viewing AMD Radeon GPU utilization";
    homepage = https://github.com/clbr/radeontop;
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = [ maintainers.rycee ];
  };
}
