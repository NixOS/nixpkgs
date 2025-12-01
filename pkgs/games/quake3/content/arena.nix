{
  lib,
  stdenv,
  fetchzip,
  requireFile,
}:

let
  version = "1.32c";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "quake3arenadata";
  inherit version;

  src = requireFile rec {
    name = "pak0.pk3";
    hash = "sha256-fOizkQYgzVCgnk8RAPQm6MYYD2iJXVifgOa9la9UvK4=";
    message = ''
      Quake 3 Arena requires the original ${name} file, from any legal source of the game.

      This could be an old CD-ROM you have lying around or you can try to buy the game.

      To my knowledge the Steam Quake-Collection-Package, is about the last legal way to get it.

      Please note, there are plenty of versions of this file online like:

      - https://github.com/nrempel/q3-server/raw/master/baseq3/pak0.pk3
      - https://archive.org/details/quake-3-arena

      However, none of these have the blessing of ID-Software and thus do not qualify.

      Once you download a version or checked your old CD-ROM, locate the ${name} file
      inside the baseq3 folder and then run the following command on it:

      nix-prefetch-url file:///path/to/baseq3/${name}
    '';
  };

  buildCommand = ''
    mkdir -p $out/baseq3
    echo 'wwwwwwwwwwwwwwww' > $out/baseq3/q3key
    ln -s $src $out/baseq3/pak0.pk3
  '';

  meta = {
    description = "Quake 3 Arena content";
    longDescription = ''
      Quake III Arena and it's demo don't offer current wide screen resolutions in the menu.

      To switch to such a resolution, you will have to enter something like this in the quake console (invoke with ~ by default)

      r_mode -1; r_customwidth 2560; r_customheight 1440; r_fullscreen 1; vid_restart

      Or call the quake commandline with these parameters

      $ quake3 +set r_mode -1 +set r_customwidth 2560 +set r_customheight 1440 +set r_fullscreen 1
    '';
    homepage = "https://www.idsoftware.com/";
    license = lib.licenses.unfreeRedistributable;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
})
