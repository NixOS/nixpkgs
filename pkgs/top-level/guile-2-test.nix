/* A Hydra jobset to test Guile-using applications and libraries with the
   Guile 2.x pre-releases.

   -- ludo@gnu.org  */

let
  allPackages = import ./all-packages.nix;

  pkgsFun = { system ? builtins.currentSystem }:
    allPackages {
      inherit system;
      config.packageOverrides = pkgs: {
        guile = pkgs.guile_1_9;
      };
    };

  pkgs = pkgsFun {};

  toJob = x: if builtins.isAttrs x then x else
    { type = "job"; systems = x; schedulingPriority = 10; };

  /* Perform a job on the given set of platforms.  The function `f' is
     called by Hydra for each platform, and should return some job
     to build on that platform.  `f' is passed the Nixpkgs collection
     for the platform in question. */
  testOn = systems: f: {system ? builtins.currentSystem}:
    if pkgs.lib.elem system systems
    then f (pkgsFun {inherit system;})
    else {};

  /* Map an attribute of the form `foo = [platforms...]'  to `testOn
     [platforms...] (pkgs: pkgs.foo)'. */
  mapTestOn = pkgs.lib.mapAttrsRecursiveCond
    (as: !(as ? type && as.type == "job"))
    (path: value:
      let
        job = toJob value;
        getPkg = pkgs:
          pkgs.lib.addMetaAttrs { schedulingPriority = toString job.schedulingPriority; }
          (pkgs.lib.getAttrFromPath path pkgs);
      in testOn job.systems getPkg);

  inherit (pkgs.lib.platforms) linux darwin cygwin allBut all;

in (mapTestOn {
  /* The package list below was obtained with:

     cat top-level/all-packages.nix                             \
     | grep -B3 'guile[^=]*$'                                   \
     | grep '^[[:blank:]]*[a-zA-Z0-9_]\+[[:blank:]]*='          \
     | sed -es'/^[[:blank:]]*\(.\+\)[[:blank:]]*=.*$/\1= linux;/g'

     with some minor edits.
   */

  guile = linux;
  guile_1_9_coverage = linux;

  autogen = linux;
  lsh = linux;
  mailutils = linux;
  mcron = linux;
  texmacs = linux;
  guileCairo = linux;
  guileGnome = linux;
  guileLib = linux;
  guileLint = linux;
  gwrap = linux;
  swig = linux;
  gnutls = linux;
  slibGuile = linux;
  dico = linux;
  trackballs = linux;
  beast = linux;
  elinks = linux;
  gnucash = linux;
  gnunet = linux;
  snd = linux;
  ballAndPaddle = linux;
  drgeo = linux;
  lilypond = linux;
})
