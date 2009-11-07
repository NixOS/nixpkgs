{
  repoUrl = "git://zen-kernel.org/kernel/zen-stable.git";
  rev = "origin/master";
  baseName = "zen-linux";
  method = "fetchgit";
  extraVars = "depth";
  eval_depth = "depth=500";
}
