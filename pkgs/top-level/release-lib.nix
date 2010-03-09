rec {
  allPackages = import ./all-packages.nix;

  pkgs = allPackages {};

  /* The working or failing letters for cross builds will be sent only to
     the following maintainers, as most package maintainers will not be
     interested in the result of cross building a package. */
  crossMaintainers = with pkgs.lib.maintainers; [ viric ];

  /* Set the Hydra scheduling priority for a job.  The default
     priority (100) should be used for most jobs.  A different
     priority should only be used for a few particularly interesting
     jobs (in terms of giving feedback to developers), such as stdenv.
  */
  prio = level: job: toJob job // { schedulingPriority = level; };

  toJob = x: if builtins.isAttrs x then x else
    { type = "job"; systems = x; schedulingPriority = 10; };

  /* Perform a job on the given set of platforms.  The function `f' is
     called by Hydra for each platform, and should return some job
     to build on that platform.  `f' is passed the Nixpkgs collection
     for the platform in question. */
  testOn = systems: f: {system ? builtins.currentSystem}:
    if pkgs.lib.elem system systems then f (allPackages {inherit system;}) else {};

  /* Similar to the testOn function, but with an additional 'crossSystem'
   * parameter for allPackages, defining the target platform for cross builds */
  testOnCross = crossSystem: systems: f: {system ? builtins.currentSystem}:
    if pkgs.lib.elem system systems then f (allPackages {inherit system
                crossSystem;}) else {};

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


  /* Similar to the testOn function, but with an additional 'crossSystem'
   * parameter for allPackages, defining the target platform for cross builds,
   * and triggering the build of the host derivation (cross built - hostDrv). */
  mapTestOnCross = crossSystem: pkgs.lib.mapAttrsRecursiveCond
    (as: !(as ? type && as.type == "job"))
    (path: value:
      let
        job = toJob value;
        getPkg = pkgs: setCrossMaintainers
          (pkgs.lib.addMetaAttrs { schedulingPriority = toString job.schedulingPriority; }
          (pkgs.lib.getAttrFromPath path pkgs));
      in testOnCross crossSystem job.systems getPkg);

  setCrossMaintainers = pkg: pkg // { meta.maintainers = crossMaintainers; };

  /* Find all packages that have a meta.platforms field listing the
     supported platforms. */
  packagesWithMetaPlatform = attrSet: 
    if builtins ? tryEval then 
      let pairs = pkgs.lib.concatMap 
        (x:
	  let pair = builtins.tryEval
	        (let 
		   attrVal = (builtins.getAttr x attrSet);
		 in
		   {val=(processPackage attrVal); 
		    attrVal = attrVal;
		    attrValIsAttrs = builtins.isAttrs attrVal;
		    });
	      success = (builtins.tryEval pair.value.attrVal).success;
	  in
          if success && pair.value.attrValIsAttrs && 
	      pair.value.val != [] then 
	    [{name= x; value=pair.value.val;}] else [])
        (builtins.attrNames attrSet);
      in
        builtins.listToAttrs pairs
    else {};
    
  # May fail as much as it wishes, we will catch the error.
  processPackage = attrSet: 
    if attrSet ? recurseForDerivations && attrSet.recurseForDerivations then 
      packagesWithMetaPlatform attrSet
    else
      if attrSet ? meta && attrSet.meta ? platforms
        then attrSet.meta.platforms
        else [];

  /* Common platform groups on which to test packages. */
  inherit (pkgs.lib.platforms) linux darwin cygwin allBut all mesaPlatforms;

  /* Platform groups for specific kinds of applications. */
  x11Supported = linux;
  gtkSupported = linux;
  ghcSupported = linux ++ ["i686-darwin"] ;

}
