{ fetchFromGitHub, fetchpatch, stdenv, wrapQtAppsHook, git, pcre, pugixml, qtbase, libsForQt5, qtmultimedia, qttools, yajl, libzip, hunspell
, boost, libGLU, lua, cmake,  which, }:

let
  luaEnv = lua.withPackages(ps: with ps; [ luazip luafilesystem lrexlib-pcre luasql-sqlite3 lua-yajl luautf8 ]);
in
stdenv.mkDerivation rec {
  pname = "mudlet";
  version = "4.3";

  src = fetchFromGitHub {
    owner = "Mudlet";
    repo = "Mudlet";
    rev = "Mudlet-${version}";
    fetchSubmodules = true;
    sha256 = "0qqdmivfwf9jmv5yx90z1fj99nlhnq762lfw6bcxgv74y4l4b4c0";
  };

  nativeBuildInputs = [ cmake wrapQtAppsHook git qttools which ];
  buildInputs = [
    pcre pugixml qtbase libsForQt5.qtkeychain qtmultimedia luaEnv libzip libGLU yajl boost hunspell
  ];

  WITH_FONTS = "NO";
  WITH_UPDATER = "NO";

  enableParallelBuilding = true;

  installPhase =  ''
    mkdir -pv $out/lib
    cp 3rdparty/edbee-lib/edbee-lib/qslog/lib/libQsLog.so $out/lib
    mkdir -pv $out/bin
    cp src/mudlet $out
    mkdir -pv $out/share/mudlet
    cp -r ../src/mudlet-lua/lua $out/share/mudlet/

    mkdir -pv $out/share/applications
    cp ../mudlet.desktop $out/share/applications/

    mkdir -pv $out/share/pixmaps
    cp -r ../mudlet.png $out/share/pixmaps/

    makeQtWrapper $out/mudlet $out/bin/mudlet \
      --set LUA_CPATH "${luaEnv}/lib/lua/${lua.luaversion}/?.so" \
      --prefix LUA_PATH : "$NIX_LUA_PATH" \
      --prefix LD_LIBRARY_PATH : "${libsForQt5.qtkeychain}/lib/" \
      --run "cd $out";
  '';

  meta = with stdenv.lib; {
    description = "Crossplatform mud client";
    homepage = http://mudlet.org/;
    maintainers = [ maintainers.wyvie maintainers.pstn ];
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
