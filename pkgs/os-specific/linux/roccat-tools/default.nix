{ stdenv, fetchurl, cmake, pkgconfig, gettext
, dbus, dbus-glib, libgaminggear, libgudev, lua
}:

stdenv.mkDerivation rec {
  name = "roccat-tools-${version}";
  version = "5.7.0";

  src = fetchurl {
    url = "mirror://sourceforge/roccat/${name}.tar.bz2";
    sha256 = "15gxplcm62167xhk65k8v6gg3j6jr0c5a64wlz72y1vfq0ai7qm6";
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

  meta = {
    description = "Tools to configure ROCCAT devices";
    homepage = http://roccat.sourceforge.net/;
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
