{ stdenv, fetchurl, cmake, pkgconfig, gettext
, dbus, dbus-glib, libgaminggear, libgudev, lua
, harfbuzz
}:

stdenv.mkDerivation rec {
  pname = "roccat-tools";
  version = "5.9.0";

  src = fetchurl {
    url = "mirror://sourceforge/roccat/${pname}-${version}.tar.bz2";
    sha256 = "12j02rzbz3iqxprz8cj4kcfcdgnqlva142ci177axqmckcq6crvg";
  };

  postPatch = ''
    sed -i -re 's,/(etc/xdg),\1,' roccateventhandler/CMakeLists.txt

    sed -i -e '/roccat_profile_dir(void).*{/,/}/ {
      /return/c \
        return g_build_path("/", g_get_user_data_dir(), "roccat", NULL);
    }' libroccat/roccat_helper.c
  '';

  nativeBuildInputs = [ cmake pkgconfig gettext ];
  buildInputs = [ dbus dbus-glib libgaminggear libgudev lua ];

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DUDEVDIR=\${out}/lib/udev/rules.d"
    "-DCMAKE_MODULE_PATH=${libgaminggear.dev}/lib/cmake"
    "-DWITH_LUA=${lua.luaversion}"
    "-DLIBDIR=lib"
  ];

  NIX_CFLAGS_COMPILE = [ "-I${harfbuzz.dev}/include/harfbuzz" ];

  meta = {
    description = "Tools to configure ROCCAT devices";
    homepage = "http://roccat.sourceforge.net/";
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
