{
  lib,
  config,
  freebsdBranches,
  freebsdBranchesCross,
}:

let
  branch =
    let
      fallbackBranch = "release/13.1.0";
      envBranch = builtins.getEnv "NIXPKGS_FREEBSD_BRANCH";
      selectedBranch =
        if config.freebsdBranch != null then
          config.freebsdBranch
        else if envBranch != "" then
          envBranch
        else
          null;
      chosenBranch = if selectedBranch != null then selectedBranch else fallbackBranch;
    in
    if freebsdBranches ? ${chosenBranch} then
      chosenBranch
    else
      throw ''
        Unknown FreeBSD branch ${chosenBranch}!
        FreeBSD branches normally look like one of:
        * `release/<major>.<minor>.0` for tagged releases without security updates
        * `releng/<major>.<minor>` for release update branches with security updates
        * `stable/<major>` for stable versions working towards the next minor release
        * `main` for the latest development version

        Set one with the NIXPKGS_FREEBSD_BRANCH environment variable or by setting `nixpkgs.config.freebsdBranch`.
      '';
in
{
  freebsd = freebsdBranches.${branch};
  freebsdCross = freebsdBranchesCross.${branch};
}
