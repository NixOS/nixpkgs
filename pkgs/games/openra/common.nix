/*  The reusable code, and package attributes, between OpenRA engine packages (engine.nix)
    and out-of-tree mod packages (mod.nix).
*/
{ stdenv, makeSetupHook, curl, unzip, dos2unix, pkgconfig, makeWrapper
, lua, mono, dotnetPackages, python
, libGL, freetype, openal, SDL2
, zenity
}:

with stdenv.lib;

let
  path = makeBinPath ([ mono python ] ++ optional (zenity != null) zenity);
  rpath = makeLibraryPath [ lua freetype openal SDL2 ];
  mkdirp = makeSetupHook { } ./mkdirp.sh;

in {
  patchEngine = dir: version: ''
    sed -i \
      -e 's/^VERSION.*/VERSION = ${version}/g' \
      -e '/fetch-geoip-db/d' \
      -e '/GeoLite2-Country.mmdb.gz/d' \
      ${dir}/Makefile

    sed -i 's|locations=.*|locations=${lua}/lib|' ${dir}/thirdparty/configure-native-deps.sh
  '';

  wrapLaunchGame = openraSuffix: ''
    # Setting TERM=xterm fixes an issue with terminfo in mono: System.Exception: Magic number is wrong: 542
    # https://github.com/mono/mono/issues/6752#issuecomment-365212655
    wrapProgram $out/lib/openra${openraSuffix}/launch-game.sh \
      --prefix PATH : "${path}" \
      --prefix LD_LIBRARY_PATH : "${rpath}" \
      --set TERM xterm

    makeWrapper $out/lib/openra${openraSuffix}/launch-game.sh $(mkdirp $out/bin)/openra${openraSuffix} \
      --run "cd $out/lib/openra${openraSuffix}"
  '';

  packageAttrs = {
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
      libGL
    ];

    # TODO: Test if this is correct.
    nativeBuildInputs = [
      curl
      unzip
      dos2unix
      pkgconfig
      makeWrapper
      mkdirp
      mono
      python
    ];

    makeFlags = [ "prefix=$(out)" ];

    doCheck = true;

    dontStrip = true;

    meta = {
      maintainers = with maintainers; [ fusion809 msteen rardiol ];
      license = licenses.gpl3;
      platforms = platforms.linux;
    };
  };
}
