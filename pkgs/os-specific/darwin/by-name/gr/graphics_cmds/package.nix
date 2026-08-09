{
  lib,
  coreutils,
  libtiff,
  oxipng,
  replaceVars,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  pname = "graphics_cmds";
  version = "1";

  buildCommand = ''
    install -m755 -D ${
      replaceVars ./extra-bins/copypng { inherit coreutils oxipng; }
    } "$out/bin/copypng"
    install -m755 -D ${replaceVars ./extra-bins/tiffutil { inherit libtiff; }} "$out/bin/tiffutil"
  '';

  meta = {
    description = "Mostly compatible replacesments for copypng and tiffutil";
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
    teams = [ lib.teams.darwin ];
  };
}
