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
  discord-rpc,
  hunspell,
  libGLU,
  libsecret,
  libsForQt5,
  libzip,
  lua,
  pcre,
  pugixml,
  qtbase,
  qtmultimedia,
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
      lua-yajl
      luafilesystem
      luasql-sqlite3
      luautf8
      luazip
      lrexlib-pcre
    ]
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "mudlet";
  version = "4.17.2";

  src = fetchFromGitHub {
    owner = "Mudlet";
    repo = "Mudlet";
    tag = "Mudlet-${finalAttrs.version}";
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
    discord-rpc
    hunspell
    libGLU
    libsecret
    libzip
    libsForQt5.qtkeychain
    luaEnv
    pcre
    pugixml
    qtbase
    qtmultimedia
    yajl
  ];

  cmakeFlags = [
    # RPATH of binary /nix/store/.../bin/... contains a forbidden reference to /build/
    (lib.cmakeBool "CMAKE_SKIP_BUILD_RPATH" true)
  ];

  env = {
    WITH_FONTS = "NO";
    WITH_UPDATER = "NO";
  };

  installPhase = ''
    runHook preInstall

    mkdir -pv $out/lib
    cp 3rdparty/edbee-lib/edbee-lib/qslog/lib/libQsLog${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib
    mkdir -pv $out/share/mudlet
    cp -r ../src/mudlet-lua/lua $out/share/mudlet/

    install -Dm 0644 ../mudlet.png -t $out/share/icons/hicolor/512x512/apps/

    cp -r ../translations $out/share/

  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications
    cp -r src/mudlet.app/ $out/Applications/mudlet.app
    wrapQtApp $out/Applications/Mudlet.app/Contents/MacOS/mudlet \
      --set LUA_CPATH "${luaEnv}/lib/lua/${lua.luaversion}/?.so" \
      --prefix DYLD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libsForQt5.qtkeychain
          discord-rpc
        ]
      }:$out/lib" \
      --chdir "$out";

  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm 0755 src/mudlet $out/bin/mudlet
    wrapQtApp $out/bin/mudlet \
      --set LUA_CPATH "${luaEnv}/lib/lua/${lua.luaversion}/?.so" \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libsForQt5.qtkeychain
          discord-rpc
        ]
      }" \
      --chdir "$out";

    install -Dm 0644 ../mudlet.desktop -t $out/share/applications/

  ''
  + ''
    runHook postInstall
  '';

  dontWrapQtApps = true;

  meta = {
    description = "Crossplatform mud client";
    homepage = "https://www.mudlet.org/";
    maintainers = builtins.attrValues {
      inherit (lib.maintainers)
        wyvie
        pstn
        cpu
        felixalbrigtsen
        ;
    };
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = lib.licenses.gpl2Plus;
    mainProgram = "mudlet";
  };
})
