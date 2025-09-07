{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  git,
  pkg-config,
  qttools,
  which,
  wrapQtAppsHook,
  boost,
  hunspell,
  libGLU,
  libsForQt5,
  libsecret,
  libzip,
  lua,
  pcre,
  pugixml,
  qtbase,
  qtmultimedia,
  discord-rpc,
  yajl,
}:

let
  overrideLua =
    let
      packageOverrides = self: super: {
        # luasql-sqlite3 master branch broke compatibility with lua 5.1. Pin to
        # an earlier commit.
        # https://github.com/lunarmodules/luasql/issues/147
        luasql-sqlite3 = super.luaLib.overrideLuarocks super.luasql-sqlite3 (drv: {
          version = "2.6.0-1-custom";
          src = fetchFromGitHub {
            owner = "lunarmodules";
            repo = "luasql";
            rev = "8c58fd6ee32faf750daf6e99af015a31402578d1";
            hash = "sha256-XlTB5O81yWCrx56m0cXQp7EFzeOyfNeqGbuiYqMrTUk=";
          };
        });
      };
    in
    lua.override { inherit packageOverrides; };

  luaEnv = overrideLua.withPackages (
    ps: with ps; [
      luazip
      luafilesystem
      lrexlib-pcre
      luasql-sqlite3
      lua-yajl
      luautf8
    ]
  );
in
stdenv.mkDerivation rec {
  pname = "mudlet";
  version = "4.17.2";

  src = fetchFromGitHub {
    owner = "Mudlet";
    repo = "Mudlet";
    rev = "Mudlet-${version}";
    fetchSubmodules = true;
    hash = "sha256-K75frptePKfHeGQNXaX4lKsLwO6Rs6AAka6hvP8MA+k=";
  };

  patches = [
    (fetchpatch {
      name = "darwin-AppKit.patch";
      url = "https://github.com/Mudlet/Mudlet/commit/68cdd404f81a6d16c80068c45fe0f10802f08d9e.patch";
      hash = "sha256-74FtcjOR/lu9ohtcoup0+gUfCQRznO48zMmb97INhdY=";
    })
  ];

  nativeBuildInputs = [
    cmake
    git
    luaEnv
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
    discord-rpc
  ];

  cmakeFlags = [
    # RPATH of binary /nix/store/.../bin/... contains a forbidden reference to /build/
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
  ];

  WITH_FONTS = "NO";
  WITH_UPDATER = "NO";

  installPhase = ''
    runHook preInstall

    mkdir -pv $out/lib
    cp 3rdparty/edbee-lib/edbee-lib/qslog/lib/libQsLog${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib
    mkdir -pv $out/share/mudlet
    cp -r ../src/mudlet-lua/lua $out/share/mudlet/

    mkdir -pv $out/share/pixmaps
    cp -r ../mudlet.png $out/share/pixmaps/

    cp -r ../translations $out/share/

  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications
    cp -r src/mudlet.app/ $out/Applications/mudlet.app
    mv $out/Applications/mudlet.app/Contents/MacOS/mudlet $out/Applications/mudlet.app/Contents/MacOS/mudlet-unwrapped
    makeQtWrapper $out/Applications/Mudlet.app/Contents/MacOS/mudlet-unwrapped $out/Applications/Mudlet.app/Contents/MacOS/mudlet \
      --set LUA_CPATH "${luaEnv}/lib/lua/${lua.luaversion}/?.so" \
      --prefix LUA_PATH : "$NIX_LUA_PATH" \
      --prefix DYLD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libsForQt5.qtkeychain
          discord-rpc
        ]
      }:$out/lib" \
      --chdir "$out";

  ''
  + lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    mkdir -pv $out/bin
    cp src/mudlet $out/bin/mudlet-unwrapped
    makeQtWrapper $out/bin/mudlet-unwrapped $out/bin/mudlet \
      --set LUA_CPATH "${luaEnv}/lib/lua/${lua.luaversion}/?.so" \
      --prefix LUA_PATH : "$NIX_LUA_PATH" \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libsForQt5.qtkeychain
          discord-rpc
        ]
      }" \
      --chdir "$out";

    mkdir -pv $out/share/applications
    cp ../mudlet.desktop $out/share/applications/

  ''
  + ''
    runHook postInstall
  '';

  meta = with lib; {
    description = "Crossplatform mud client";
    homepage = "https://www.mudlet.org/";
    maintainers = with maintainers; [
      wyvie
      pstn
      cpu
      felixalbrigtsen
    ];
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.gpl2Plus;
    mainProgram = "mudlet";
  };
}
