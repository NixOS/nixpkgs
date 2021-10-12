{ fetchFromGitHub, lib, stdenv, wrapQtAppsHook, git, pcre, pugixml, qtbase, libsForQt5, libsecret, qtmultimedia, qttools, yajl, libzip, hunspell
, boost, libGLU, lua, cmake,  which, pkg-config, }:

let
  luaEnv = lua.withPackages(ps: with ps; [
    luazip luafilesystem lrexlib-pcre luasql-sqlite3 lua-yajl luautf8
  ]);
in
stdenv.mkDerivation rec {
  pname = "mudlet";
  version = "4.12.0";

  src = fetchFromGitHub {
    owner = "Mudlet";
    repo = "Mudlet";
    rev = "Mudlet-${version}";
    fetchSubmodules = true;
    sha256 = "023plm5mwm15xikmdh1mq3gx1n7y4a0r0kw9fvk3rvm9brm78hzp";
  };

  nativeBuildInputs = [ pkg-config cmake wrapQtAppsHook git qttools which ];
  buildInputs = [
    pcre pugixml qtbase libsForQt5.qtkeychain qtmultimedia luaEnv libsecret libzip libGLU yajl boost hunspell
  ];

  WITH_FONTS = "NO";
  WITH_UPDATER = "NO";

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
      --prefix LD_LIBRARY_PATH : "${libsForQt5.qtkeychain}/lib/" \
      --run "cd $out";
  '';

  meta = with lib; {
    description = "Crossplatform mud client";
    homepage = "http://mudlet.org/";
    maintainers = [ maintainers.wyvie maintainers.pstn ];
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
