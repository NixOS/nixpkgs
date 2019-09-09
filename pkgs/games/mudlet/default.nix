{ fetchFromGitHub, fetchpatch, stdenv, wrapQtAppsHook, pcre, pugixml, qtbase, qtmultimedia, qttools, yajl, libzip, hunspell
, boost, libGLU, lua, cmake,  which, }:

let
  luaEnv = lua.withPackages(ps: with ps; [ luazip luafilesystem lrexlib-pcre luasql-sqlite3 lua-yajl luautf8 ]);
in
stdenv.mkDerivation rec {
  pname = "mudlet";
  version = "4.0.3";

  src = fetchFromGitHub {
    owner = "Mudlet";
    repo = "Mudlet";
    rev = "Mudlet-${version}";
    fetchSubmodules = true;
    sha256 = "18bl4k0qgh47d9k5ipfvypfj1il678c0ws64a8adn8k21jajzkik";
  };

  patches = [
    ( fetchpatch {
      url = "https://github.com/Mudlet/Mudlet/commit/3c8f12b6d757894d92ec2e2c9b12b91f69e8a3b6.patch";
      name = "hunspell-1.7";
      sha256 = "09qggls4pzpd8h9h10fbpfd7x3kr7fjp9axdwz98igpwy714n98j";
    })
  ];

  nativeBuildInputs = [ cmake wrapQtAppsHook qttools which ];
  buildInputs = [
    pcre pugixml qtbase qtmultimedia luaEnv libzip libGLU yajl boost hunspell
  ];

  WITH_FONTS = "NO";
  WITH_UPDATER = "NO";

  enableParallelBuilding = true;

  installPhase =  ''
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
