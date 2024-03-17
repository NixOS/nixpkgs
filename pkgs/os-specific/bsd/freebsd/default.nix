{ stdenv, lib, config, newScope, buildPackages, pkgsHostHost, makeSetupHook, substituteAll, runtimeShell, ... }:
let
  versions = builtins.fromJSON (builtins.readFile ./versions.json);
in lib.makeScope newScope (self:
let
  byName = lib.packagesFromDirectoryRecursive {
    callPackage = self.callPackage;
    directory = ./by-name;
  };
in byName // (with self; { inherit stdenv;
  #stdenv = if stdenv.cc.isClang then stdenv else llvmPackages.stdenv;
  compatIsNeeded = !self.stdenv.hostPlatform.isFreeBSD;

  # build a self which is parameterized with whatever the targeted version is
  # so e.g. pkgsCross.x86_64-freebsd.freebsd.branches."releng/14.0".buildFreebsd will get you
  # freebsd.branches."releng/14.0"
  buildFreebsd = buildPackages.freebsd.overrideScope (_: _: { inherit hostBranch; });
  branches = lib.flip lib.mapAttrs versions (branch: _: self.overrideScope (_: _: { hostBranch = branch; }));

  packages13 = self.overrideScope (_: _: { hostBranch = "release/13.2.0"; });
  packages14 = self.overrideScope (_: _: { hostBranch = "release/14.0.0"; });
  packagesGit = self.overrideScope (_: _: { hostBranch = "main"; });

  hostBranch = let
    supportedBranches = builtins.attrNames (lib.filterAttrs (k: v: v.supported) versions);
    fallbackBranch = let
        branchRegex = "releng/.*";
        candidateBranches = builtins.filter (name: builtins.match branchRegex name != null) supportedBranches;
      in
        lib.last (lib.naturalSort candidateBranches);
    envBranch = builtins.getEnv "NIXPKGS_FREEBSD_BRANCH";
    selectedBranch =
      if config.freebsdBranch != null then
        config.freebsdBranch
      else if envBranch != "" then
        envBranch
      else null;
    chosenBranch = if selectedBranch != null then selectedBranch else fallbackBranch;
  in
    if versions ? ${chosenBranch} then chosenBranch else throw ''
      Unknown FreeBSD branch ${chosenBranch}!
      FreeBSD branches normally look like one of:
      * `release/<major>.<minor>.0` for tagged releases without security updates
      * `releng/<major>.<minor>` for release update branches with security updates
      * `stable/<major>` for stable versions working towards the next minor release
      * `main` for the latest development version

      Set one with the NIXPKGS_FREEBSD_BRANCH environment variable or by setting `nixpkgs.config.freebsdBranch`.
    '';

  sourceData = versions.${hostBranch};
  versionData = sourceData.version;
  hostVersion = versionData.revision;

  hostArchBsd = {
    x86_64 = "amd64";
    aarch64 = "arm64";
    i486 = "i386";
    i586 = "i386";
    i686 = "i386";
  }.${self.stdenv.hostPlatform.parsed.cpu.name} or self.stdenv.hostPlatform.parsed.cpu.name;

  patchesRoot = ./patches/${hostVersion};

  compatIfNeeded = lib.optional compatIsNeeded compat;

  # for cross-compiling or bootstrapping
  install-wrapper = builtins.readFile ./install-wrapper.sh;
  boot-install = buildPackages.writeShellScriptBin "boot-install" (install-wrapper + ''
    ${xinstallBootstrap}/bin/xinstall "''${args[@]}"
  '');

  # libs, bins, and data
  libncurses-tinfo = if hostVersion == "13.2" then libncurses else byName.libncurses-tinfo;

  drm-kmod-firmware-amd = self.drm-kmod-firmware.override { withIntel = false; };
  drm-kmod-firmware-intel = self.drm-kmod-firmware.override { withAmd = false; };
}))
