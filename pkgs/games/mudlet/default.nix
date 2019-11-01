{ fetchFromGitHub, fetchpatch, stdenv, wrapQtAppsHook, pcre, pugixml, qtbase, qtmultimedia, qttools, yajl, libzip, hunspell
, boost, libGLU, lua, cmake,  which, }:

let
  luaEnv = lua.withPackages(ps: with ps; [ luazip luafilesystem lrexlib-pcre luasql-sqlite3 lua-yajl luautf8 ]);
in
stdenv.mkDerivation rec {
  pname = "mudlet";
  version = "4.1.2";

  src = fetchFromGitHub {
    owner = "Mudlet";
    repo = "Mudlet";
    rev = "Mudlet-${version}";
    fetchSubmodules = true;
    sha256 = "1d6r51cj8a71hmhzsayd2far4hliwz5pnrsaj3dn39m7c0iikgdn";
  };

  nativeBuildInputs = [ cmake wrapQtAppsHook qttools which ];
  buildInputs = [
    pcre pugixml qtbase qtmultimedia luaEnv libzip libGLU yajl boost hunspell
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
