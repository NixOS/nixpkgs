{
  lib,
  stdenv,
  requireFile,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "quake3arenadata";
  version = "1.32c";

  src = requireFile {
    name = "pak0.pk3";
    hash = "sha256-fOizkQYgzVCgnk8RAPQm6MYYD2iJXVifgOa9la9UvK4=";
    # The actionable guidance lives in meta.problems.broken below; this only
    # satisfies requireFile's API and is not reached in practice, since the
    # broken problem refuses evaluation before this builder would run.
    message = "pak0.pk3 has not been added to the Nix store.";
  };

  buildCommand = ''
    mkdir -p $out/baseq3
    echo 'wwwwwwwwwwwwwwww' > $out/baseq3/q3key
    ln -s $src $out/baseq3/pak0.pk3
  '';

  preferLocalBuild = true;

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
    # pak0.pk3 cannot be fetched automatically; it must be added to the store by
    # hand. Until the store path exists the package cannot be built, so flag it
    # as a broken problem. This both keeps automated evaluation (Hydra,
    # nixpkgs-review, ...) from tripping over the build failure and shows the
    # user a friendly, actionable message instead of a generic "broken" error.
    # Providing the file makes the store path exist and clears the problem.
    #
    # tryEval guards against restrictive configs: reading the unfree src's store
    # path throws an "unfree license" error under e.g. Hydra's tarball job,
    # which would otherwise abort meta evaluation. Context is discarded so the
    # probe never realises the file; the only catchable error is that guard, in
    # which case we simply treat the data as unavailable.
    problems =
      let
        probe = builtins.tryEval (
          builtins.pathExists (builtins.unsafeDiscardStringContext finalAttrs.src.outPath)
        );
      in
      lib.optionalAttrs (!(probe.success && probe.value)) {
        broken.message = ''
          Quake 3 Arena requires the original ${finalAttrs.src.name} file, from any legal source of the game.

          This could be an old CD-ROM you have lying around or you can try to buy the game.

          To my knowledge the Steam Quake-Collection-Package, is about the last legal way to get it.

          Please note, there are plenty of versions of this file online like:

          - https://github.com/nrempel/q3-server/raw/master/baseq3/pak0.pk3
          - https://archive.org/details/quake-3-arena

          However, none of these have the blessing of ID-Software and thus do not qualify.

          Once you download a version or checked your old CD-ROM, locate the ${finalAttrs.src.name} file
          inside the baseq3 folder and then run the following command on it:

          nix-prefetch-url file:///path/to/baseq3/${finalAttrs.src.name}
        '';
      };
    maintainers = [ ];
  };
})
