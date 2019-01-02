# Based on: pkgs/games/openra/default.nix
# Based on: https://build.opensuse.org/package/show/home:fusion809/openra-ura
{ stdenv, fetchFromGitHub, dos2unix, pkgconfig, makeWrapper
, lua, mono, dotnetPackages, python
, libGL, openal, SDL2
, zenity ? null
, mod
, engine
, engineMods ? []
}:

with stdenv.lib;

let
  path = makeBinPath ([ mono python ] ++ optional (zenity != null) zenity);
  rpath = makeLibraryPath [ lua openal SDL2 ];

in stdenv.mkDerivation rec {
  name = "openra-${mod.name}-${mod.version}";

  srcs = [
    mod.src
    engine.src
  ];

  sourceRoot = ".";

  buildInputs = with dotnetPackages; [
    FuzzyLogicLibrary
    MaxMindDb
    MaxMindGeoIP2
    MonoNat
    NewtonsoftJson
    NUnit3
    NUnitConsole
    OpenNAT
    RestSharp
    SharpFont
    SharpZipLib
    SmartIrc4net
    StyleCopMSBuild
    StyleCopPlusMSBuild
  ] ++ [
    dos2unix
    pkgconfig
    makeWrapper
    lua
    mono
    python
    libGL
    openal
    SDL2
  ];

  postUnpack = ''
    mv ${engine.src.name} mod
    cd mod
  '';

  prePatch = ''
    dos2unix Makefile
  '';

  patches = [ mod.makefilePatch ];

  postPatch = ''
    sed -i 's/^VERSION.*/VERSION = ${mod.version}/g' Makefile

    dos2unix *.md

    sed -i \
      -e 's/^VERSION.*/VERSION = ${engine.version}/g' \
      -e '/fetch-geoip-db/d' \
      -e '/GeoLite2-Country.mmdb.gz/d' \
      ${engine.src.name}/Makefile

    sed -i 's|locations=.*|locations=${lua}/lib|' ${engine.src.name}/thirdparty/configure-native-deps.sh
  '';

  configurePhase = ''
    make version VERSION=${escapeShellArg mod.version}
    ( cd ${engine.src.name}; make version VERSION=${escapeShellArg engine.version} )
  '';

  makeFlags = "PREFIX=$(out)";

  doCheck = true;
  checkTarget = "test";

  installPhase = ''
    mkdir -p $out/lib/openra-${mod.name}
    substitute ${./launch-game.sh} $out/lib/openra-${mod.name}/launch-game.sh \
      --subst-var out \
      --subst-var-by name ${escapeShellArg mod.name} \
      --subst-var-by title ${escapeShellArg mod.title}
    chmod +x $out/lib/openra-${mod.name}/launch-game.sh

    # Setting TERM=xterm fixes an issue with terminfo in mono: System.Exception: Magic number is wrong: 542
    # https://github.com/mono/mono/issues/6752#issuecomment-365212655
    wrapProgram $out/lib/openra-${mod.name}/launch-game.sh \
      --prefix PATH : "${path}" \
      --prefix LD_LIBRARY_PATH : "${rpath}" \
      --set TERM xterm

    mkdir -p $out/bin
    makeWrapper $out/lib/openra-${mod.name}/launch-game.sh $out/bin/openra-${mod.name} \
      --run "cd $out/lib/openra-${mod.name}"

    cp -r ${engine.src.name}/{${concatStringsSep "," [
      "glsl"
      "lua"
      "AUTHORS"
      "COPYING"
      "Eluant.dll*"
      "FuzzyLogicLibrary.dll"
      "'global mix database.dat'"
      "ICSharpCode.SharpZipLib.dll"
      "MaxMind.Db.dll"
      "OpenAL-CS.dll"
      "OpenAL-CS.dll.config"
      "Open.Nat.dll"
      "OpenRA.Game.exe"
      "OpenRA.Platforms.Default.dll"
      "OpenRA.Server.exe"
      "OpenRA.Utility.exe"
      "rix0rrr.BeaconLib.dll"
      "SDL2-CS.dll"
      "SDL2-CS.dll.config"
      "SharpFont.dll"
      "SharpFont.dll.config"
      "VERSION"
    ]}} $out/lib/openra-${mod.name}

    mkdir $out/lib/openra-${mod.name}/mods
    cp -r ${engine.src.name}/mods/{common${concatStrings (map (s: "," + s) engineMods)},modcontent} $out/lib/openra-${mod.name}/mods
    cp -r mods/${mod.name} $out/lib/openra-${mod.name}/mods

    mkdir -p $out/share/applications
    substitute ${./openra-mod.desktop} $out/share/applications/openra-${mod.name}.desktop \
      --subst-var-by name ${escapeShellArg mod.name} \
      --subst-var-by title ${escapeShellArg mod.title}

    mkdir -p $out/share/doc/packages/openra-${mod.name}
    cp README.md $out/share/doc/packages/openra-${mod.name}/README.md

    mkdir -p $out/share/pixmaps
    [[ -e mods/${mod.name}/icon.png ]] && mod_icon=mods/${mod.name}/icon.png || mod_icon=packaging/linux/mod_256x256.png
    cp "$mod_icon" $out/share/pixmaps/openra-${mod.name}.png

    mkdir -p $out/share/icons/hicolor/{16x16,32x32,48x48,64x64,128x128,256x256}/apps
    for size in 16 32 48 64 128 256; do
      size=''${size}x''${size}
      cp packaging/linux/mod_''${size}.png "$out/share/icons/hicolor/''${size}/apps/openra-${mod.name}.png"
    done
  '';

  dontStrip = true;

  meta = {
    description = mod.description;
    homepage = mod.homepage;
    maintainers = with maintainers; [ msteen ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
