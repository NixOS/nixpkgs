{ lib
, stdenv
, unzip
}:

attrs@{
  # "mod" (valid for modpacks too), "game", or "txp" (texture pack)
  type ? "mod",
  # The technical name of the package (eg. "minetest_game")
  technical_name ? attrs.pname,
  src,
  nativeBuildInputs ? [],
  dontConfigure ? true,
  dontBuild ? true,
  ...
}:

let
  typeLocations = {mod = "mods"; game = "games"; txp = "textures";};
  targetDirectory =
    typeLocations."${type}" or (abort (
      "Unknown minetest package type ${type}. " +
      "Valid types are: ${toString (lib.attrNames typeLocations)}"));

in stdenv.mkDerivation (attrs // {
  nativeBuildInputs = [
    # The standard archive format for minetest content is zip
    unzip
  ] ++ nativeBuildInputs;

  inherit dontConfigure dontBuild;

  installPhase = ''
    runHook preInstall

    target=$out/share/minetest/${targetDirectory}/${technical_name}
    mkdir -p $target
    cp -r . $target

    runHook postInstall
  '';
})
