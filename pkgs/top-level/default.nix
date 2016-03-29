/* This file composes the Nix Packages collection.  That is, it
   imports the functions that build the various packages, and calls
   them with appropriate arguments.  The result is a set of all the
   packages in the Nix Packages collection for some particular
   platform. */


{ # The system (e.g., `i686-linux') for which to build the packages.
  system ? builtins.currentSystem

, # The standard environment to use.  Only used for bootstrapping.  If
  # null, the default standard environment is used.
  bootStdenv ? null

, # Non-GNU/Linux OSes are currently "impure" platforms, with their libc
  # outside of the store.  Thus, GCC, GFortran, & co. must always look for
  # files in standard system directories (/usr/include, etc.)
  noSysDirs ? (system != "x86_64-freebsd" && system != "i686-freebsd"
               && system != "x86_64-solaris"
               && system != "x86_64-kfreebsd-gnu")

  # More flags for the bootstrapping of stdenv.
, gccWithCC ? true
, gccWithProfiling ? true

, # Allow a configuration attribute set to be passed in as an
  # argument.  Otherwise, it's read from $NIXPKGS_CONFIG or
  # ~/.nixpkgs/config.nix.
  config ? null

, crossSystem ? null
, platform ? null

  # List of paths that are used to build the base channel, which is used as
  # a reference for security updates.
, defaultPackages ? {
    adapters = import ../stdenv/adapters.nix;
    builders = import ../build-support/trivial-builders.nix;
    stdenv = import ./stdenv.nix;
    all = import ./all-packages.nix;
    aliases = import ./aliases.nix;
  }

  # Additional list of packages, similar to defaultPackages, which is used
  # to apply security fixes to a few packages which would be compiled, and
  # to patch any of their dependencies, to have a fast turn-around.
, quickfixPackages ? null

  # When a set of quickfix packages is defined, this flag is used to enable
  # patching packages which are depending on the packages which are updated
  # in the quickfix packages.
  #
  # This flag highly recommend to be `true` on a user/server system, while
  # it is suggested to set it to `false` on buildfarms, as we do not want to
  # distribute, and use space for all the variants of the patched packages,
  # on the buildfarm servers.
, doPatchWithDependencies ? true
}:


let config_ = config; platform_ = platform; in # rename the function arguments

let

  lib = import ../../lib;

  # The contents of the configuration file found at $NIXPKGS_CONFIG or
  # $HOME/.nixpkgs/config.nix.
  # for NIXOS (nixos-rebuild): use nixpkgs.config option
  config =
    let
      toPath = builtins.toPath;
      getEnv = x: if builtins ? getEnv then builtins.getEnv x else "";
      pathExists = name:
        builtins ? pathExists && builtins.pathExists (toPath name);

      configFile = getEnv "NIXPKGS_CONFIG";
      homeDir = getEnv "HOME";
      configFile2 = homeDir + "/.nixpkgs/config.nix";

      configExpr =
        if config_ != null then config_
        else if configFile != "" && pathExists configFile then import (toPath configFile)
        else if homeDir != "" && pathExists configFile2 then import (toPath configFile2)
        else {};

    in
      # allow both:
      # { /* the config */ } and
      # { pkgs, ... } : { /* the config */ }
      if builtins.isFunction configExpr
        then configExpr { inherit pkgs; }
        else configExpr;

  # Allow setting the platform in the config file. Otherwise, let's use a reasonable default (pc)

  platformAuto = let
      platforms = (import ./platforms.nix);
    in
      if system == "armv6l-linux" then platforms.raspberrypi
      else if system == "armv7l-linux" then platforms.armv7l-hf-multiplatform
      else if system == "armv5tel-linux" then platforms.sheevaplug
      else if system == "mips64el-linux" then platforms.fuloong2f_n32
      else if system == "x86_64-linux" then platforms.pc64
      else if system == "i686-linux" then platforms.pc32
      else platforms.pcBase;

  platform = if platform_ != null then platform_
    else config.platform or platformAuto;

  topLevelArguments = {
    inherit system bootStdenv noSysDirs gccWithCC gccWithProfiling config
      crossSystem platform lib;
  };

  # Allow packages to be overridden globally via the `packageOverrides'
  # configuration option, which must be a function that takes `pkgs'
  # as an argument and returns a set of new or overridden packages.
  # The `packageOverrides' function is called with the *original*
  # (un-overridden) set of packages, allowing packageOverrides
  # attributes to refer to the original attributes (e.g. "foo =
  # ... pkgs.foo ...").
  pkgs = lib.fix' (unfixPkgsWithPackages defaultPackages);

  unfixPkgsWithPackages =
    unfixPkgsWithOverridesWithPackages (self: config.packageOverrides or (super: {}));

  # Return the complete set of packages, after applying the overrides
  # returned by the `overrider' function (see above).  Warning: this
  # function is very expensive!
  unfixPkgsWithOverridesWithPackages = overrider: packages:
    let
      stdenvAdapters = self: super:
        let res = packages.adapters self; in res // {
          stdenvAdapters = res;
        };

      trivialBuilders = self: super:
        (packages.builders {
          inherit lib; inherit (self) stdenv; inherit (self.xorg) lndir;
        });

      stdenvDefault = self: super: (packages.stdenv topLevelArguments) {} pkgs;

      allPackagesArgs = topLevelArguments // {
        pkgsWithOverrides = overrider:
          lib.fix' (unfixPkgsWithOverridesWithPackages overrider defaultPackages);
      };
      allPackages = self: super:
        let res = packages.all allPackagesArgs res self;
        in res;

      aliases = self: super: packages.aliases super;

      # stdenvOverrides is used to avoid circular dependencies for building
      # the standard build environment. This mechanism uses the override
      # mechanism to implement some staged compilation of the stdenv.
      #
      # We don't want stdenv overrides in the case of cross-building, or
      # otherwise the basic overridden packages will not be built with the
      # crossStdenv adapter.
      stdenvOverrides = self: super:
        lib.optionalAttrs (crossSystem == null && super.stdenv ? overrides)
          (super.stdenv.overrides super);

      customOverrides = self: super:
        lib.optionalAttrs (bootStdenv == null) (overrider self super);
    in
      lib.extends customOverrides (
        lib.extends stdenvOverrides (
          lib.extends aliases (
            lib.extends allPackages (
              lib.extends stdenvDefault (
                lib.extends trivialBuilders (
                  lib.extends stdenvAdapters (
                    self: {})))))));

  # Apply ABI compatible fixes:
  #  1. This will cause the recompilation of packages which have a different
  #     derivation in quickfix, than what they have in the default packages.
  #  2. This will patch any of the dependencies to substitute the hash of
  #     the default packages by the corresponding hash of the quickfix
  #     packages which got recompiled.
  #
  # If there is no quickfix to apply, or if we are bootstrapping the
  # compilation environment, then there is no need for making any patches.
  maybeApplyAbiCompatiblePatches = pkgs:
    if bootStdenv == null && quickfixPackages != null then
      applyAbiCompatiblePatches pkgs
    else
      pkgs;

  applyAbiCompatiblePatches = pkgs: with lib;
    let
      #  - pkgs: set of packages compiled by default with no quickfix
      #          applied.
      #
      #  - onefix: set of packages compiled against `pkgs`, without doing a
      #            fix point. This is used to recompiled packages which have
      #            security fixes, without recompiling any of the packages
      #            which are depending on them.
      #
      #  - recfix: set of packages compiled against the set of fixed
      #            packages (`abifix`). This is used as a probe to see if
      #            any of the dependencies got fixed or patched.
      #
      #  - abifix: set of fixed packaged, which are both fixed and patched.
      #
      onefix = unfixPkgsWithPackages quickfixPackages pkgs;
      recfix = unfixPkgsWithPackages quickfixPackages abifix;
      abifix = zipWithUpdatedPackages ["pkgs"] pkgs onefix recfix;

      # Traverse all packages. For each package, take the quickfix version
      # of the package, and patch it if any of its dependency is different
      # than the one used for building it in `pkgs`.
      zipWithUpdatedPackages = path: pkgs: onefix: recfix:
        zipAttrsWith (name: values:
          let pkgsName = concatStringsSep "." (path ++ [name]); in
          # Somebody added / removed a package in quickfix?
          assert builtins.length values == 3;
          let p = elemAt values 0; o = elemAt values 1; r = elemAt values 2; in
          if name == "pkgs" && path == ["pkgs"] then abifix
          else if isAttrs p then assert isAttrs o && isAttrs r;
            if isDerivation p then assert isDerivation o && isDerivation r;
              addErrorContext "While evaluating package ${pkgsName}"
                (patchUpdatedDependencies pkgsName p o r)
            else
              zipWithUpdatedPackages (path ++ [name]) p o r
          else
            o
        ) [pkgs onefix recfix];

      # For each package:
      #
      #  1. Take the onefix version of the package.
      #
      #  2. Rename it, such that we can safely patch any of the packages
      #     which depend on this one.
      #
      #  3. Check if the arguments of the nix expression imported by
      #     `callPackage` are different. if none, return the renamed
      #     package.
      #
      #  4. Otherwise, replace hashes of the `onefix` package, by the hashes
      #     of the `recfix` package.
      #
      patchUpdatedDependencies = name: pkg: onefix: recfix:
        let
          # Get build inputs added by the mkDerivation function.
          getUnfilteredDepenencies = drv:
            drv.nativeBuildInputs or [];

          # Warn if the package does not provide any list of build inputs.
          warnIfUnableToFindDeps = drv:
            if drv ? nativeBuildInputs then true
            else assert __trace "Security issue: Unable to locate buildInputs of `${name}`." true; true;

          # Note, we need to check the drv.outPath to add some strictness
          # such that we eliminate derivation which might assert when they
          # are evaluated.
          validDeps = drv:
            let res = builtins.tryEval (isDerivation drv && isString drv.outPath); in
            res.success && res.value;

          # Get the list of dependencies added listed in build inputs,
          # but filter out any input which cannot be properly evaluated
          # to a derivation. The reason being that some arguments are
          # ordinary values, and some arguments are packages specific to one
          # architecture.
          getDeps = drv:
            filter validDeps (getUnfilteredDepenencies drv);

          assertSameName = {old, new}@result:
            assert (builtins.parseDrvName old.name).name == (builtins.parseDrvName new.name).name;
            result;

          differentDeps = {old, new}:
            old != new;

          # Zip build inputs from the old package with the build inputs of
          # the new package definition.
          zipBuildInputs =
            zipListsWith (old: new: assertSameName { inherit old new; });

          # Extract the list of dependency given as build inputs, and filter
          # out identical packages.
          buildInputsDiff = {old, new}:
            let oldDeps = getDeps old; newDeps = getDeps new; in
            # assert __trace "${name}.${toString old}: oldDeps: ${toString (map (drv: (builtins.parseDrvName drv).name) oldDeps)}" true;
            # assert __trace "${name}.${toString new}: newDeps: ${toString (map (drv: (builtins.parseDrvName drv).name) newDeps)}" true;
            assert (length oldDeps) == (length newDeps);
            filter differentDeps (zipBuildInputs oldDeps newDeps);

          # Derivation might be different because of the dependency of the
          # fixed derivation is different. We have to recursively append all
          # the differencies.
          recursiveBuildInputsDiff = {old, new}@args:
            if new ? buildInputsDifferences
            then new.buildInputsDifferences
            else
              let depDiffs = buildInputsDiff args; in
              depDiffs ++ concatMap recursiveBuildInputsDiff depDiffs;

          dependencyDifferencies =
             flip map (recursiveBuildInputsDiff { old = onefix; new = recfix; }) ({old, new}: {
               old = builtins.unsafeDiscardStringContext (toString old);
               new = toString new;
             });

          # If the name of the onefix does not have the same
          # length, use the old name instead. This might cause a
          # problem if people do not use --leq while updating.
          onefixRenamed =
            if stringLength pkg.name == stringLength onefix.name
            then onefix
            else
              overrideDerivation onefix (drv: {
                name = pkg.name;
              });

          # If any of the dependencies is different, then patch the package,
          # and return the patched version of the package, otherwise return
          # the renamed package.
          patchedDrv =
            if length dependencyDifferencies != 0 then
              assert warnIfUnableToFindDeps onefix;
              patchDependencies onefixRenamed dependencyDifferencies
            else
              onefixRenamed;
        in
          # As the merge operator is not lazy enough, we have to create a
          # new attribute set which inherit all the names from the original
          # package, while the resolution of the name is made through the
          # recfix version of the package. This way, only the outPath and
          # outDrv are resolved through the patched version of the package.
          mapAttrs (n: v: recfix."${n}") pkg // {
            inherit (patchedDrv) outPath drvPath;
            buildInputsDifferences = dependencyDifferencies;
          };

      # Create a derivation which is replace all the hashes of `pkgs`, by
      # the fixed and patched versions of the `abifix` packages.
      patchDependencies = drv: replaceList:
        # The list is not bounded, thus to avoid having huge command lines,
        # we create a file with all the renamed hashes.
        let sedExpr = {old, new}: "s|${baseNameOf old}|${baseNameOf new}|g;\n"; in
        let sedScript = pkgs.writeTextFile {
            name = drv.name + "-patch";
            text = concatStrings (map sedExpr replaceList);
          };
        in
          pkgs.runCommand "${drv.name}" { nixStore = "${pkgs.nix}/bin/nix-store"; } ''
            $nixStore --dump ${drv} | \
              sed -e 's|${baseNameOf drv}|'$(basename $out)'|g' -f ${sedScript} | \
              $nixStore --restore $out
          '';

    in
      if doPatchWithDependencies then abifix
      else onefix;

in
  maybeApplyAbiCompatiblePatches pkgs
