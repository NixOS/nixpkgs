/* A Hydra jobset to test Guile-using applications and libraries with the
   Guile 2.x pre-releases.

   -- ludo@gnu.org  */

let
  allPackages = import ./all-packages.nix;

  pkgs = allPackages {
    packageOverrides = pkgs: pkgs // { guile = pkgs.guile_1_9; };
  };

  inherit (pkgs.lib.platforms) linux darwin cygwin allBut all;

in {
  /* The package list below was obtained with:

     cat top-level/all-packages.nix				\
     | grep -B3 'guile[^=]*$'					\
     | grep '^[[:blank:]]*[a-zA-Z0-9_]\+[[:blank:]]*='		\
     | sed -es'/^[[:blank:]]*\(.\+\)[[:blank:]]*=.*$/\1= linux;/g'

     with some minor edits.
   */

  guile = linux;

  lsh = linux;
  mailutils = linux;
  mcron = linux;
  guileLib = linux;
  guileLint = linux;
  gwrap = linux;
  gnutls = linux;
  dico = linux;
  trackballs = linux;
  beast = linux;
  elinks = linux;
  gnunet = linux;
  snd = linux;
  ballAndPaddle = linux;
  drgeo = linux;
  lilypond = linux;
}
