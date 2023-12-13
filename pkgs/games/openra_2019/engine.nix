/*  The package defintion for an OpenRA engine.
    It shares code with `mod.nix` by what is defined in `common.nix`.
    Similar to `mod.nix` it is a generic package definition,
    in order to make it easy to define multiple variants of the OpenRA engine.
    For each mod provided by the engine, a wrapper script is created,
    matching the naming convention used by `mod.nix`.
    This package could be seen as providing a set of in-tree mods,
    while the `mod.nix` pacakges provide a single out-of-tree mod.
*/
{ lib, stdenv
, packageAttrs
, patchEngine
, wrapLaunchGame
, engine
}:

stdenv.mkDerivation (lib.recursiveUpdate packageAttrs rec {
  pname = "openra_2019";
  version = "${engine.name}-${engine.version}";

  src = engine.src;

  postPatch = patchEngine "." version;

  configurePhase = ''
    runHook preConfigure

    make version VERSION=${lib.escapeShellArg version}

    runHook postConfigure
  '';

  buildFlags = [ "DEBUG=false" "default" "man-page" ];

  checkTarget = "nunit test";

  installTargets = [
    "install"
    "install-linux-icons"
    "install-linux-desktop"
    "install-linux-appdata"
    "install-linux-mime"
    "install-man-page"
  ];

  postInstall = ''
    ${wrapLaunchGame "" "openra"}

    ${lib.concatStrings (map (mod: ''
      makeWrapper $out/bin/openra $out/bin/openra-${mod} --add-flags Game.Mod=${mod}
    '') engine.mods)}
  '';

  meta = {
    inherit (engine) description homepage;
  };
})
