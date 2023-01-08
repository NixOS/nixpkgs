{ lib, config }:

stdenv:

let
  checkMeta = import ./check-meta.nix {
    inherit lib config;
    # Nix itself uses the `system` field of a derivation to decide where
    # to build it. This is a bit confusing for cross compilation.
    inherit (stdenv) hostPlatform;
  };

  # Based off lib.makeExtensible, with modifications:
  makeDerivationExtensible = rattrs:
    let
      # NOTE: The following is a hint that will be printed by the Nix cli when
      # encountering an infinite recursion. It must not be formatted into
      # separate lines, because Nix would only show the last line of the comment.

      # An infinite recursion here can be caused by having the attribute names of expression `e` in `.overrideAttrs(finalAttrs: previousAttrs: e)` depend on `finalAttrs`. Only the attribute values of `e` can depend on `finalAttrs`.
      args = rattrs (args // { inherit finalPackage; });
      #              ^^^^

      finalPackage =
        mkDerivationSimple
          (f0:
            let
              f = self: super:
                # Convert f0 to an overlay. Legacy is:
                #   overrideAttrs (super: {})
                # We want to introduce self. We follow the convention of overlays:
                #   overrideAttrs (self: super: {})
                # Which means the first parameter can be either self or super.
                # This is surprising, but far better than the confusion that would
                # arise from flipping an overlay's parameters in some cases.
                let x = f0 super;
                in
                if builtins.isFunction x
                then
                # Can't reuse `x`, because `self` comes first.
                # Looks inefficient, but `f0 super` was a cheap thunk.
                  f0 self super
                else x;
            in
            makeDerivationExtensible
              (self: let super = rattrs self; in super // f self super))
          args;
    in
    finalPackage;

  # makeDerivationExtensibleConst == makeDerivationExtensible (_: attrs),
  # but pre-evaluated for a slight improvement in performance.
  makeDerivationExtensibleConst = attrs:
    mkDerivationSimple
      (f0:
        let
          f = self: super:
            let x = f0 super;
            in
            if builtins.isFunction x
            then
              f0 self super
            else x;
        in
        makeDerivationExtensible (self: attrs // f self attrs))
      attrs;

  mkDerivationSimple = overrideAttrs:


    # `mkDerivation` wraps the builtin `derivation` function to
    # produce derivations that use this stdenv and its shell.
    #
    # See also:
    #
    # * https://nixos.org/nixpkgs/manual/#sec-using-stdenv
    #   Details on how to use this mkDerivation function
    #
    # * https://nixos.org/manual/nix/stable/expressions/derivations.html#derivations
    #   Explanation about derivations in general
    {
      # These types of dependencies are all exhaustively documented in
      # the "Specifying Dependencies" section of the "Standard
      # Environment" chapter of the Nixpkgs manual.

      # TODO(@Ericson2314): Stop using legacy dep attribute names

      #                           host offset -> target offset
      depsBuildBuild ? [ ] # -1 -> -1
    , depsBuildBuildPropagated ? [ ] # -1 -> -1
    , nativeBuildInputs ? [ ] # -1 ->  0  N.B. Legacy name
    , propagatedNativeBuildInputs ? [ ] # -1 ->  0  N.B. Legacy name
    , depsBuildTarget ? [ ] # -1 ->  1
    , depsBuildTargetPropagated ? [ ] # -1 ->  1

    , depsHostHost ? [ ] #  0 ->  0
    , depsHostHostPropagated ? [ ] #  0 ->  0
    , buildInputs ? [ ] #  0 ->  1  N.B. Legacy name
    , propagatedBuildInputs ? [ ] #  0 ->  1  N.B. Legacy name

    , depsTargetTarget ? [ ] #  1 ->  1
    , depsTargetTargetPropagated ? [ ] #  1 ->  1

    , checkInputs ? [ ]
    , installCheckInputs ? [ ]

      # Configure Phase
    , configureFlags ? [ ]
    , cmakeFlags ? [ ]
    , mesonFlags ? [ ]
    , # Target is not included by default because most programs don't care.
      # Including it then would cause needless mass rebuilds.
      #
      # TODO(@Ericson2314): Make [ "build" "host" ] always the default / resolve #87909
      configurePlatforms ? lib.optionals
        (stdenv.hostPlatform != stdenv.buildPlatform || config.configurePlatformsByDefault)
        [ "build" "host" ]

      # TODO(@Ericson2314): Make unconditional / resolve #33599
      # Check phase
    , doCheck ? config.doCheckByDefault or false

      # TODO(@Ericson2314): Make unconditional / resolve #33599
      # InstallCheck phase
    , doInstallCheck ? config.doCheckByDefault or false

    , # TODO(@Ericson2314): Make always true and remove / resolve #178468
      strictDeps ? if config.strictDepsByDefault then true else stdenv.hostPlatform != stdenv.buildPlatform

    , enableParallelBuilding ? config.enableParallelBuildingByDefault

    , meta ? { }
    , passthru ? { }
    , pos ? # position used in error messages and for meta.position
      (if attrs.meta.description or null != null
      then builtins.unsafeGetAttrPos "description" attrs.meta
      else if attrs.version or null != null
      then builtins.unsafeGetAttrPos "version" attrs
      else builtins.unsafeGetAttrPos "name" attrs)
    , separateDebugInfo ? false
    , outputs ? [ "out" ]
    , __darwinAllowLocalNetworking ? false
    , __impureHostDeps ? [ ]
    , __propagatedImpureHostDeps ? [ ]
    , sandboxProfile ? ""
    , propagatedSandboxProfile ? ""

    , hardeningEnable ? [ ]
    , hardeningDisable ? [ ]

    , patches ? [ ]

    , __contentAddressed ? (! attrs ? outputHash) # Fixed-output drvs can't be content addressed too
        && config.contentAddressedByDefault

    , ...
    } @ attrs:

    let
      # TODO(@oxij, @Ericson2314): This is here to keep the old semantics, remove when
      # no package has `doCheck = true`.
      doCheck' = doCheck && stdenv.buildPlatform.canExecute stdenv.hostPlatform;
      doInstallCheck' = doInstallCheck && stdenv.buildPlatform.canExecute stdenv.hostPlatform;

      separateDebugInfo' = separateDebugInfo && stdenv.hostPlatform.isLinux && !(stdenv.hostPlatform.useLLVM or false);
      outputs' = outputs ++ lib.optional separateDebugInfo' "debug";

      noNonNativeDeps = builtins.length
        (depsBuildTarget ++ depsBuildTargetPropagated
          ++ depsHostHost ++ depsHostHostPropagated
          ++ buildInputs ++ propagatedBuildInputs
          ++ depsTargetTarget ++ depsTargetTargetPropagated) == 0;
      dontAddHostSuffix = attrs ? outputHash && !noNonNativeDeps || !stdenv.hasCC;
      supportedHardeningFlags = [ "fortify" "stackprotector" "pie" "pic" "strictoverflow" "format" "relro" "bindnow" ];
      # Musl-based platforms will keep "pie", other platforms will not.
      # If you change this, make sure to update section `{#sec-hardening-in-nixpkgs}`
      # in the nixpkgs manual to inform users about the defaults.
      defaultHardeningFlags =
        if stdenv.hostPlatform.isMusl &&
          # Except when:
          #    - static aarch64, where compilation works, but produces segfaulting dynamically linked binaries.
          #    - static armv7l, where compilation fails.
          !(stdenv.hostPlatform.isAarch && stdenv.hostPlatform.isStatic)
        then supportedHardeningFlags
        else lib.remove "pie" supportedHardeningFlags;
      enabledHardeningOptions =
        if builtins.elem "all" hardeningDisable
        then [ ]
        else lib.subtractLists hardeningDisable (defaultHardeningFlags ++ hardeningEnable);
      # hardeningDisable additionally supports "all".
      erroneousHardeningFlags = lib.subtractLists supportedHardeningFlags (hardeningEnable ++ lib.remove "all" hardeningDisable);

      checkDependencyList = checkDependencyList' [ ];
      checkDependencyList' = positions: name: deps: lib.flip lib.imap1 deps (index: dep:
        if lib.isDerivation dep || isNull dep || builtins.typeOf dep == "string" || builtins.typeOf dep == "path" then dep
        else if lib.isList dep then checkDependencyList' ([ index ] ++ positions) name dep
        else throw "Dependency is not of a valid type: ${lib.concatMapStrings (ix: "element ${toString ix} of ") ([index] ++ positions)}${name} for ${attrs.name or attrs.pname}");

      checkExecutableOnBuild = listName: dep:
        if (lib.isDerivation dep && dep ? stdenv) then
          if (stdenv.buildPlatform.canExecute dep.stdenv.hostPlatform)
          then dep
          else
            # TODO(@Artturin) remove workaround
            # if something has __spliced then it has been spliced but may not have a buildHost
            # example: perl's cross-compilation is bad and has some hacks
            # perl's mini output is only created when buildPlatfom != hostPlatform
            # > pkgsCross.aarch64-multiplatform.buildPackages.perl.mini
            # <does not exist>
            # > pkgsCross.aarch64-multiplatform.buildPackages.__splicedPackages.perl.mini.__spliced
            # { targetTarget = «derivation ...perl-aarch64-unknown-linux-gnu...»; }
            if (!dep ? __spliced) then
              # workaround overrideAttrs not preserving splicing https://github.com/NixOS/nixpkgs/issues/132651
              if (!dep ? pythonSitePackages && !dep ? provides && !dep ? pythonAttr) then
                lib.warn "${dep.name} in ${attrs.name or attrs.pname}'s ${listName} not executable on build" dep
              else dep
            else dep
        else dep;

      nameToSplicedName = {
        depsBuildBuild = "buildBuild";
        nativeBuildInputs = "buildHost";
        depsBuildTarget = "buildTarget";

        depsHostHost = "hostHost";
        buildInputs = "hostTarget";
        depsTargetTarget = "targetTarget";

        depsBuildBuildPropagated = "buildBuild";
        propagatedNativeBuildInputs = "buildHost";
        depsBuildTargetPropagated = "buildTarget";

        depsHostHostPropagated = "hostHost";
        propagatedBuildInputs = "hostTarget";
        depsTargetTargetPropagated = "targetTarget";
      };

      checkDepListAndChooseSpliced = itemsSupposedToBeExecutable: listName: list:
        map (dep: if itemsSupposedToBeExecutable then checkExecutableOnBuild listName dep else dep)
          (map (drv: drv.__spliced.${nameToSplicedName.${listName}} or drv) (checkDependencyList listName list))
      ;

    in
    if builtins.length erroneousHardeningFlags != 0
    then
      abort
        ("mkDerivation was called with unsupported hardening flags: " + lib.generators.toPretty { } {
          inherit erroneousHardeningFlags hardeningDisable hardeningEnable supportedHardeningFlags;
        })
    else
      let
        doCheck = doCheck';
        doInstallCheck = doInstallCheck';

        outputs = outputs';

        references = nativeBuildInputs ++ buildInputs
          ++ propagatedNativeBuildInputs ++ propagatedBuildInputs;

        dependencies = map (map lib.chooseDevOutputs) [
          [
            (checkDepListAndChooseSpliced true "depsBuildBuild" depsBuildBuild)
            (checkDepListAndChooseSpliced true "nativeBuildInputs" (nativeBuildInputs
              ++ lib.optional separateDebugInfo' ../../build-support/setup-hooks/separate-debug-info.sh
              ++ lib.optional stdenv.hostPlatform.isWindows ../../build-support/setup-hooks/win-dll-link.sh
              ++ lib.optionals doCheck checkInputs
              ++ lib.optionals doInstallCheck' installCheckInputs))
            (checkDepListAndChooseSpliced true "depsBuildTarget" depsBuildTarget)
          ]
          [
            (checkDepListAndChooseSpliced false "depsHostHost" depsHostHost)
            (checkDepListAndChooseSpliced false "buildInputs" buildInputs)
          ]
          [
            (checkDepListAndChooseSpliced false "depsTargetTarget" depsTargetTarget)
          ]
        ];
        propagatedDependencies = map (map lib.chooseDevOutputs) [
          [
            (checkDepListAndChooseSpliced true "depsBuildBuildPropagated" depsBuildBuildPropagated)
            (checkDepListAndChooseSpliced true "propagatedNativeBuildInputs" propagatedNativeBuildInputs)
            (checkDepListAndChooseSpliced true "depsBuildTargetPropagated" depsBuildTargetPropagated)
          ]
          [
            (checkDepListAndChooseSpliced false "depsHostHostPropagated" depsHostHostPropagated)
            (checkDepListAndChooseSpliced false "propagatedBuildInputs" propagatedBuildInputs)
          ]
          [
            (checkDepListAndChooseSpliced false "depsTargetTargetPropagated" depsTargetTargetPropagated)
          ]
        ];

        computedSandboxProfile =
          lib.concatMap (input: input.__propagatedSandboxProfile or [ ])
            (stdenv.extraNativeBuildInputs
              ++ stdenv.extraBuildInputs
              ++ lib.concatLists dependencies);

        computedPropagatedSandboxProfile =
          lib.concatMap (input: input.__propagatedSandboxProfile or [ ])
            (lib.concatLists propagatedDependencies);

        computedImpureHostDeps =
          lib.unique (lib.concatMap (input: input.__propagatedImpureHostDeps or [ ])
            (stdenv.extraNativeBuildInputs
              ++ stdenv.extraBuildInputs
              ++ lib.concatLists dependencies));

        computedPropagatedImpureHostDeps =
          lib.unique (lib.concatMap (input: input.__propagatedImpureHostDeps or [ ])
            (lib.concatLists propagatedDependencies));

        derivationArg =
          (removeAttrs attrs
            [
              "meta"
              "passthru"
              "pos"
              "checkInputs"
              "installCheckInputs"
              "__darwinAllowLocalNetworking"
              "__impureHostDeps"
              "__propagatedImpureHostDeps"
              "sandboxProfile"
              "propagatedSandboxProfile"
            ])
          // (lib.optionalAttrs (attrs ? name || (attrs ? pname && attrs ? version)) {
            name =
              let
                # Indicate the host platform of the derivation if cross compiling.
                # Fixed-output derivations like source tarballs shouldn't get a host
                # suffix. But we have some weird ones with run-time deps that are
                # just used for their side-affects. Those might as well since the
                # hash can't be the same. See #32986.
                hostSuffix = lib.optionalString
                  (stdenv.hostPlatform != stdenv.buildPlatform && !dontAddHostSuffix)
                  "-${stdenv.hostPlatform.config}";
                # Disambiguate statically built packages. This was originally
                # introduce as a means to prevent nix-env to get confused between
                # nix and nixStatic. This should be also achieved by moving the
                # hostSuffix before the version, so we could contemplate removing
                # it again.
                staticMarker = lib.optionalString stdenv.hostPlatform.isStatic "-static";
              in
              lib.strings.sanitizeDerivationName (
                if attrs ? name
                then attrs.name + hostSuffix
                else "${attrs.pname}${staticMarker}${hostSuffix}-${attrs.version}"
              );
          }) // {
            builder = attrs.realBuilder or stdenv.shell;
            args = attrs.args or [ "-e" (attrs.builder or ./default-builder.sh) ];
            inherit stdenv;

            # The `system` attribute of a derivation has special meaning to Nix.
            # Derivations set it to choose what sort of machine could be used to
            # execute the build, The build platform entirely determines this,
            # indeed more finely than Nix knows or cares about. The `system`
            # attribute of `buildPlatfom` matches Nix's degree of specificity.
            # exactly.
            inherit (stdenv.buildPlatform) system;

            userHook = config.stdenv.userHook or null;
            __ignoreNulls = true;

            inherit strictDeps;

            depsBuildBuild = lib.elemAt (lib.elemAt dependencies 0) 0;
            nativeBuildInputs = lib.elemAt (lib.elemAt dependencies 0) 1;
            depsBuildTarget = lib.elemAt (lib.elemAt dependencies 0) 2;
            depsHostHost = lib.elemAt (lib.elemAt dependencies 1) 0;
            buildInputs = lib.elemAt (lib.elemAt dependencies 1) 1;
            depsTargetTarget = lib.elemAt (lib.elemAt dependencies 2) 0;

            depsBuildBuildPropagated = lib.elemAt (lib.elemAt propagatedDependencies 0) 0;
            propagatedNativeBuildInputs = lib.elemAt (lib.elemAt propagatedDependencies 0) 1;
            depsBuildTargetPropagated = lib.elemAt (lib.elemAt propagatedDependencies 0) 2;
            depsHostHostPropagated = lib.elemAt (lib.elemAt propagatedDependencies 1) 0;
            propagatedBuildInputs = lib.elemAt (lib.elemAt propagatedDependencies 1) 1;
            depsTargetTargetPropagated = lib.elemAt (lib.elemAt propagatedDependencies 2) 0;

            # This parameter is sometimes a string, sometimes null, and sometimes a list, yuck
            configureFlags = let inherit (lib) optional elem; in
              (/**/ if lib.isString configureFlags then lib.warn "String 'configureFlags' is deprecated and will be removed in release 23.05. Please use a list of strings. Derivation name: ${derivationArg.name}, file: ${pos.file or "unknown file"}" [ configureFlags ]
              else if configureFlags == null then lib.warn "Null 'configureFlags' is deprecated and will be removed in release 23.05. Please use a empty list instead '[]'. Derivation name: ${derivationArg.name}, file: ${pos.file or "unknown file"}" [ ]
              else configureFlags)
              ++ optional (elem "build" configurePlatforms) "--build=${stdenv.buildPlatform.config}"
              ++ optional (elem "host" configurePlatforms) "--host=${stdenv.hostPlatform.config}"
              ++ optional (elem "target" configurePlatforms) "--target=${stdenv.targetPlatform.config}";

            cmakeFlags =
              let
                explicitFlags =
                  if lib.isString cmakeFlags then
                    lib.warn
                      "String 'cmakeFlags' is deprecated and will be removed in release 23.05. Please use a list of strings. Derivation name: ${derivationArg.name}, file: ${pos.file or "unknown file"}"
                      [ cmakeFlags ]
                  else if cmakeFlags == null then
                    lib.warn
                      "Null 'cmakeFlags' is deprecated and will be removed in release 23.05. Please use a empty list instead '[]'. Derivation name: ${derivationArg.name}, file: ${pos.file or "unknown file"}"
                      [ ]
                  else
                    cmakeFlags;

                crossFlags = [
                  "-DCMAKE_SYSTEM_NAME=${lib.findFirst lib.isString "Generic" (lib.optional (!stdenv.hostPlatform.isRedox) stdenv.hostPlatform.uname.system)}"
                ] ++ lib.optionals (stdenv.hostPlatform.uname.processor != null) [
                  "-DCMAKE_SYSTEM_PROCESSOR=${stdenv.hostPlatform.uname.processor}"
                ] ++ lib.optionals (stdenv.hostPlatform.uname.release != null) [
                  "-DCMAKE_SYSTEM_VERSION=${stdenv.hostPlatform.uname.release}"
                ] ++ lib.optionals (stdenv.hostPlatform.isDarwin) [
                  "-DCMAKE_OSX_ARCHITECTURES=${stdenv.hostPlatform.darwinArch}"
                ] ++ lib.optionals (stdenv.buildPlatform.uname.system != null) [
                  "-DCMAKE_HOST_SYSTEM_NAME=${stdenv.buildPlatform.uname.system}"
                ] ++ lib.optionals (stdenv.buildPlatform.uname.processor != null) [
                  "-DCMAKE_HOST_SYSTEM_PROCESSOR=${stdenv.buildPlatform.uname.processor}"
                ] ++ lib.optionals (stdenv.buildPlatform.uname.release != null) [
                  "-DCMAKE_HOST_SYSTEM_VERSION=${stdenv.buildPlatform.uname.release}"
                ];
              in
              explicitFlags ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) crossFlags;

            mesonFlags =
              let
                explicitFlags =
                  if lib.isString mesonFlags then
                    lib.warn
                      "String 'mesonFlags' is deprecated and will be removed in release 23.05. Please use a list of strings. Derivation name: ${derivationArg.name}, file: ${pos.file or "unknown file"}"
                      [ mesonFlags ]
                  else if mesonFlags == null then
                    lib.warn
                      "Null 'mesonFlags' is deprecated and will be removed in release 23.05. Please use a empty list instead '[]'. Derivation name: ${derivationArg.name}, file: ${pos.file or "unknown file"}"
                      [ ]
                  else
                    mesonFlags;

                # See https://mesonbuild.com/Reference-tables.html#cpu-families
                cpuFamily = platform: with platform;
                  /**/ if isAarch32 then "arm"
                else if isAarch64 then "aarch64"
                else if isx86_32 then "x86"
                else if isx86_64 then "x86_64"
                else platform.parsed.cpu.family + builtins.toString platform.parsed.cpu.bits;

                crossFile = builtins.toFile "cross-file.conf" ''
                  [properties]
                  needs_exe_wrapper = ${lib.boolToString (!stdenv.buildPlatform.canExecute stdenv.hostPlatform)}

                  [host_machine]
                  system = '${stdenv.targetPlatform.parsed.kernel.name}'
                  cpu_family = '${cpuFamily stdenv.targetPlatform}'
                  cpu = '${stdenv.targetPlatform.parsed.cpu.name}'
                  endian = ${if stdenv.targetPlatform.isLittleEndian then "'little'" else "'big'"}

                  [binaries]
                  llvm-config = 'llvm-config-native'
                '';
                crossFlags = lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [ "--cross-file=${crossFile}" ];
              in
              crossFlags ++ explicitFlags;

            inherit patches;

            inherit doCheck doInstallCheck;

            inherit outputs;
          } // lib.optionalAttrs (__contentAddressed) {
            inherit __contentAddressed;
            # Provide default values for outputHashMode and outputHashAlgo because
            # most people won't care about these anyways
            outputHashAlgo = attrs.outputHashAlgo or "sha256";
            outputHashMode = attrs.outputHashMode or "recursive";
          } // lib.optionalAttrs (enableParallelBuilding) {
            enableParallelChecking = attrs.enableParallelChecking or true;
          } // lib.optionalAttrs (hardeningDisable != [ ] || hardeningEnable != [ ] || stdenv.hostPlatform.isMusl) {
            NIX_HARDENING_ENABLE = enabledHardeningOptions;
          } // lib.optionalAttrs (stdenv.hostPlatform.isx86_64 && stdenv.hostPlatform ? gcc.arch) {
            requiredSystemFeatures = attrs.requiredSystemFeatures or [ ] ++ [ "gccarch-${stdenv.hostPlatform.gcc.arch}" ];
          } // lib.optionalAttrs (stdenv.buildPlatform.isDarwin) {
            inherit __darwinAllowLocalNetworking;
            # TODO: remove lib.unique once nix has a list canonicalization primitive
            __sandboxProfile =
              let
                profiles = [ stdenv.extraSandboxProfile ] ++ computedSandboxProfile ++ computedPropagatedSandboxProfile ++ [ propagatedSandboxProfile sandboxProfile ];
                final = lib.concatStringsSep "\n" (lib.filter (x: x != "") (lib.unique profiles));
              in
              final;
            __propagatedSandboxProfile = lib.unique (computedPropagatedSandboxProfile ++ [ propagatedSandboxProfile ]);
            __impureHostDeps = computedImpureHostDeps ++ computedPropagatedImpureHostDeps ++ __propagatedImpureHostDeps ++ __impureHostDeps ++ stdenv.__extraImpureHostDeps ++ [
              "/dev/zero"
              "/dev/random"
              "/dev/urandom"
              "/bin/sh"
            ];
            __propagatedImpureHostDeps = computedPropagatedImpureHostDeps ++ __propagatedImpureHostDeps;
          };

        validity = checkMeta { inherit meta attrs; };

        # The meta attribute is passed in the resulting attribute set,
        # but it's not part of the actual derivation, i.e., it's not
        # passed to the builder and is not a dependency.  But since we
        # include it in the result, it *is* available to nix-env for queries.
        meta = {
          # `name` above includes cross-compilation cruft,
          # is under assert, and is sanitized.
          # Let's have a clean always accessible version here.
          name = attrs.name or "${attrs.pname}-${attrs.version}";

          # If the packager hasn't specified `outputsToInstall`, choose a default,
          # which is the name of `p.bin or p.out or p` along with `p.man` when
          # present.
          #
          # If the packager has specified it, it will be overridden below in
          # `// meta`.
          #
          #   Note: This default probably shouldn't be globally configurable.
          #   Services and users should specify outputs explicitly,
          #   unless they are comfortable with this default.
          outputsToInstall =
            let
              hasOutput = out: builtins.elem out outputs;
            in
            [ (lib.findFirst hasOutput null ([ "bin" "out" ] ++ outputs)) ]
              ++ lib.optional (hasOutput "man") "man";
        }
        // attrs.meta or { }
        # Fill `meta.position` to identify the source location of the package.
        // lib.optionalAttrs (pos != null) {
          position = pos.file + ":" + toString pos.line;
        } // {
          # Expose the result of the checks for everyone to see.
          inherit (validity) unfree broken unsupported insecure;
          available = validity.valid != "no"
            && (if config.checkMetaRecursively or false
          then lib.all (d: d.meta.available or true) references
          else true);
        };

      in

      lib.extendDerivation
        validity.handled
        ({
          # A derivation that always builds successfully and whose runtime
          # dependencies are the original derivations build time dependencies
          # This allows easy building and distributing of all derivations
          # needed to enter a nix-shell with
          #   nix-build shell.nix -A inputDerivation
          inputDerivation = derivation (derivationArg // {
            # Add a name in case the original drv didn't have one
            name = derivationArg.name or "inputDerivation";
            # This always only has one output
            outputs = [ "out" ];

            # Propagate the original builder and arguments, since we override
            # them and they might contain references to build inputs
            _derivation_original_builder = derivationArg.builder;
            _derivation_original_args = derivationArg.args;

            builder = stdenv.shell;
            # The bash builtin `export` dumps all current environment variables,
            # which is where all build input references end up (e.g. $PATH for
            # binaries). By writing this to $out, Nix can find and register
            # them as runtime dependencies (since Nix greps for store paths
            # through $out to find them)
            args = [ "-c" "export > $out" ];
          });

          inherit meta passthru overrideAttrs;
        } //
        # Pass through extra attributes that are not inputs, but
        # should be made available to Nix expressions using the
        # derivation (e.g., in assertions).
        passthru)
        (derivation derivationArg);

in
fnOrAttrs:
if builtins.isFunction fnOrAttrs
then makeDerivationExtensible fnOrAttrs
else makeDerivationExtensibleConst fnOrAttrs
