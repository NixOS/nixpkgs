{stdenv, fetchurl, libX11, imake, libXt, libXaw, libXpm, libXext
, withNethackLevels ? true
}:
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "xsok";
  version = "1.02";

  src = fetchurl {
    url = "http://http.debian.net/debian/pool/main/x/xsok/xsok_1.02.orig.tar.gz";
    sha256 = "0f4z53xsy4w8x8zp5jya689xp3rcfpi5wri2ip0qa8nk3sw7zj73";
  };

  nethackLevels = fetchurl {
    url = "https://www.electricmonk.nl/data/nethack/nethack.def";
    sha256 = "057ircp13hfpy513c7wpyp986hsvhqs7km98w4k39f5wkvp3dj02";
  };

  buildInputs = [libX11 libXt libXaw libXpm libXext];
  nativeBuildInputs = [imake];

  NIX_CFLAGS_COMPILE=" -isystem ${libXpm.dev}/include/X11 ";

  preConfigure = ''
    sed -e "s@/usr/@$out/share/@g" -i src/Imakefile
    sed -e "s@/var/games/xsok@./.xsok/@g" -i src/Imakefile
    sed -e '/chown /d' -i src/Imakefile
    sed -e '/chmod /d' -i src/Imakefile
    sed -e '/InstallAppDefaults/d' -i src/Imakefile
  '';

  makeFlags = ["BINDIR=$(out)/bin"];

  postInstall = stdenv.lib.optionalString withNethackLevels ''
    gzip < ${nethackLevels} > "$out/share/games/lib/xsok/Nethack.def.gz"
    echo Nethack > "$out/share/games/lib/xsok/gametypes"
  '';

  meta = {
    inherit version;
    description = "A generic Sokoban game for X11";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = https://tracker.debian.org/pkg/xsok;
  };
}
