{ lib
, stdenv
, fetchFromGitHub
, cmake
, git
, pkg-config
, qttools
, which
, wrapQtAppsHook
, boost
, hunspell
, libGLU
, libsForQt5
, libsecret
, libzip
, lua
, pcre
, pugixml
, qtbase
, qtmultimedia
, yajl
}:

let
  luaEnv = lua.withPackages(ps: with ps; [
    luazip luafilesystem lrexlib-pcre luasql-sqlite3 lua-yajl luautf8
  ]);
in
stdenv.mkDerivation rec {
  pname = "mudlet";
  version = "4.15.1";

  src = fetchFromGitHub {
    owner = "Mudlet";
    repo = "Mudlet";
    rev = "Mudlet-${version}";
    fetchSubmodules = true;
    hash = "sha256-GnTQc0Jh4YaQnfy7fYsTCACczlzWCQ+auKYoU9ET83M=";
  };

  nativeBuildInputs = [
    cmake
    git
    pkg-config
    qttools
    which
    wrapQtAppsHook
  ];

  buildInputs = [
    boost
    hunspell
    libGLU
    libsForQt5.qtkeychain
    libsecret
    libzip
    luaEnv
    pcre
    pugixml
    qtbase
    qtmultimedia
    yajl
  ];

  cmakeFlags = [
    # RPATH of binary /nix/store/.../bin/... contains a forbidden reference to /build/
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
  ];

  WITH_FONTS = "NO";
  WITH_UPDATER = "NO";

  installPhase =  ''
    runHook preInstall

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
      --chdir "$out";

    runHook postInstall
  '';

  meta = with lib; {
    description = "Crossplatform mud client";
    homepage = "https://www.mudlet.org/";
    maintainers = [ maintainers.wyvie maintainers.pstn ];
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
  };
}
