{ lib, stdenv, fetchurl, cmake, pkg-config, gettext
, dbus, dbus-glib, libgaminggear, libgudev, lua
, harfbuzz, runtimeShell, coreutils, kmod
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

    substituteInPlace udev/90-roccat-kone.rules \
      --replace "/bin/sh" "${runtimeShell}" \
      --replace "/sbin/modprobe" "${kmod}/bin/modprobe" \
      --replace "/bin/echo" "${coreutils}/bin/echo"
  '';

  nativeBuildInputs = [ cmake pkg-config gettext ];
  buildInputs = [ dbus dbus-glib libgaminggear libgudev lua ];

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
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
  };
}
