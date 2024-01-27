{ lib, config }:

stdenv:

let
  # Lib attributes are inherited to the lexical scope for performance reasons.
  inherit (lib)
    any
    assertMsg
    attrNames
    boolToString
    chooseDevOutputs
    concatLists
    concatMap
    concatMapStrings
    concatStringsSep
    elem
    elemAt
    extendDerivation
    filter
    findFirst
    flip
    head
    imap1
    isAttrs
    isBool
    isDerivation
    isInt
    isList
    isString
    mapAttrs
    mapNullable
    optional
    optionalAttrs
    optionalString
    optionals
    remove
    splitString
    subtractLists
    unique
  ;

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
      args = rattrs (args // { inherit finalPackage overrideAttrs; });
      #              ^^^^

      overrideAttrs = f0:
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
            (self: let super = rattrs self; in super // (if builtins.isFunction f0 || f0?__functor then f self super else f0));

      finalPackage =
        mkDerivationSimple overrideAttrs args;

    in finalPackage;

  #makeDerivationExtensibleConst = attrs: makeDerivationExtensible (_: attrs);
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
          makeDerivationExtensible (self: attrs // (if builtins.isFunction f0 || f0?__functor then f self attrs else f0)))
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

#                                 host offset -> target offset
  depsBuildBuild                    ? [] # -1 -> -1
, depsBuildBuildPropagated          ? [] # -1 -> -1
, nativeBuildInputs                 ? [] # -1 ->  0  N.B. Legacy name
, propagatedNativeBuildInputs       ? [] # -1 ->  0  N.B. Legacy name
, depsBuildTarget                   ? [] # -1 ->  1
, depsBuildTargetPropagated         ? [] # -1 ->  1

, depsHostHost                      ? [] #  0 ->  0
, depsHostHostPropagated            ? [] #  0 ->  0
, buildInputs                       ? [] #  0 ->  1  N.B. Legacy name
, propagatedBuildInputs             ? [] #  0 ->  1  N.B. Legacy name

, depsTargetTarget                  ? [] #  1 ->  1
, depsTargetTargetPropagated        ? [] #  1 ->  1

, checkInputs                       ? []
, installCheckInputs                ? []
, nativeCheckInputs                 ? []
, nativeInstallCheckInputs          ? []

# Configure Phase
, configureFlags ? []
, cmakeFlags ? []
, mesonFlags ? []
, # Target is not included by default because most programs don't care.
  # Including it then would cause needless mass rebuilds.
  #
  # TODO(@Ericson2314): Make [ "build" "host" ] always the default / resolve #87909
  configurePlatforms ? optionals
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

, meta ? {}
, passthru ? {}
, pos ? # position used in error messages and for meta.position
    (if attrs.meta.description or null != null
      then builtins.unsafeGetAttrPos "description" attrs.meta
      else if attrs.version or null != null
      then builtins.unsafeGetAttrPos "version" attrs
      else builtins.unsafeGetAttrPos "name" attrs)
, separateDebugInfo ? false
, outputs ? [ "out" ]
, __darwinAllowLocalNetworking ? false
, __impureHostDeps ? []
, __propagatedImpureHostDeps ? []
, sandboxProfile ? ""
, propagatedSandboxProfile ? ""

, hardeningEnable ? []
, hardeningDisable ? []

, patches ? []

, __contentAddressed ?
  (! attrs ? outputHash) # Fixed-output drvs can't be content addressed too
  && config.contentAddressedByDefault

# Experimental.  For simple packages mostly just works,
# but for anything complex, be prepared to debug if enabling.
, __structuredAttrs ? config.structuredAttrsByDefault or false

, env ? { }

, ... } @ attrs:

# Policy on acceptable hash types in nixpkgs
assert attrs ? outputHash -> (
  let algo =
    attrs.outputHashAlgo or (head (splitString "-" attrs.outputHash));
  in
  if algo == "md5" then
    throw "Rejected insecure ${algo} hash '${attrs.outputHash}'"
  else
    true
);

let
  # TODO(@oxij, @Ericson2314): This is here to keep the old semantics, remove when
  # no package has `doCheck = true`.
  doCheck' = doCheck && stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  doInstallCheck' = doInstallCheck && stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  separateDebugInfo' = separateDebugInfo && stdenv.hostPlatform.isLinux;
  outputs' = outputs ++ optional separateDebugInfo' "debug";

  # Turn a derivation into its outPath without a string context attached.
  # See the comment at the usage site.
  unsafeDerivationToUntrackedOutpath = drv:
    if isDerivation drv
    then builtins.unsafeDiscardStringContext drv.outPath
    else drv;

  noNonNativeDeps = builtins.length (depsBuildTarget ++ depsBuildTargetPropagated
                                  ++ depsHostHost ++ depsHostHostPropagated
                                  ++ buildInputs ++ propagatedBuildInputs
                                  ++ depsTargetTarget ++ depsTargetTargetPropagated) == 0;
  dontAddHostSuffix = attrs ? outputHash && !noNonNativeDeps || !stdenv.hasCC;

  hardeningDisable' = if any (x: x == "fortify") hardeningDisable
    # disabling fortify implies fortify3 should also be disabled
    then unique (hardeningDisable ++ [ "fortify3" ])
    else hardeningDisable;
  knownHardeningFlags = [
    "bindnow"
    "format"
    "fortify"
    "fortify3"
    "pic"
    "pie"
    "relro"
    "stackprotector"
    "strictoverflow"
  ];
  defaultHardeningFlags =
    (if stdenv.hasCC then stdenv.cc else {}).defaultHardeningFlags or
      # fallback safe-ish set of flags
      (remove "pie" knownHardeningFlags);
  enabledHardeningOptions =
    if builtins.elem "all" hardeningDisable'
    then []
    else subtractLists hardeningDisable' (defaultHardeningFlags ++ hardeningEnable);
  # hardeningDisable additionally supports "all".
  erroneousHardeningFlags = subtractLists knownHardeningFlags (hardeningEnable ++ remove "all" hardeningDisable);

  checkDependencyList = checkDependencyList' [];
  checkDependencyList' = positions: name: deps: flip imap1 deps (index: dep:
    if isDerivation dep || dep == null || builtins.isString dep || builtins.isPath dep then dep
    else if isList dep then checkDependencyList' ([index] ++ positions) name dep
    else throw "Dependency is not of a valid type: ${concatMapStrings (ix: "element ${toString ix} of ") ([index] ++ positions)}${name} for ${attrs.name or attrs.pname}");
in if builtins.length erroneousHardeningFlags != 0
then abort ("mkDerivation was called with unsupported hardening flags: " + lib.generators.toPretty {} {
  inherit erroneousHardeningFlags hardeningDisable hardeningEnable knownHardeningFlags;
})
else let
  doCheck = doCheck';
  doInstallCheck = doInstallCheck';
  buildInputs' = buildInputs
         ++ optionals doCheck checkInputs
         ++ optionals doInstallCheck installCheckInputs;
  nativeBuildInputs' = nativeBuildInputs
         ++ optional separateDebugInfo' ../../build-support/setup-hooks/separate-debug-info.sh
         ++ optional stdenv.hostPlatform.isWindows ../../build-support/setup-hooks/win-dll-link.sh
         ++ optionals doCheck nativeCheckInputs
         ++ optionals doInstallCheck nativeInstallCheckInputs;

  outputs = outputs';

  references = nativeBuildInputs ++ buildInputs
            ++ propagatedNativeBuildInputs ++ propagatedBuildInputs;

  dependencies = map (map chooseDevOutputs) [
    [
      (map (drv: drv.__spliced.buildBuild or drv) (checkDependencyList "depsBuildBuild" depsBuildBuild))
      (map (drv: drv.__spliced.buildHost or drv) (checkDependencyList "nativeBuildInputs" nativeBuildInputs'))
      (map (drv: drv.__spliced.buildTarget or drv) (checkDependencyList "depsBuildTarget" depsBuildTarget))
    ]
    [
      (map (drv: drv.__spliced.hostHost or drv) (checkDependencyList "depsHostHost" depsHostHost))
      (map (drv: drv.__spliced.hostTarget or drv) (checkDependencyList "buildInputs" buildInputs'))
    ]
    [
      (map (drv: drv.__spliced.targetTarget or drv) (checkDependencyList "depsTargetTarget" depsTargetTarget))
    ]
  ];
  propagatedDependencies = map (map chooseDevOutputs) [
    [
      (map (drv: drv.__spliced.buildBuild or drv) (checkDependencyList "depsBuildBuildPropagated" depsBuildBuildPropagated))
      (map (drv: drv.__spliced.buildHost or drv) (checkDependencyList "propagatedNativeBuildInputs" propagatedNativeBuildInputs))
      (map (drv: drv.__spliced.buildTarget or drv) (checkDependencyList "depsBuildTargetPropagated" depsBuildTargetPropagated))
    ]
    [
      (map (drv: drv.__spliced.hostHost or drv) (checkDependencyList "depsHostHostPropagated" depsHostHostPropagated))
      (map (drv: drv.__spliced.hostTarget or drv) (checkDependencyList "propagatedBuildInputs" propagatedBuildInputs))
    ]
    [
      (map (drv: drv.__spliced.targetTarget or drv) (checkDependencyList "depsTargetTargetPropagated" depsTargetTargetPropagated))
    ]
  ];

  computedSandboxProfile =
    concatMap (input: input.__propagatedSandboxProfile or [])
      (stdenv.extraNativeBuildInputs
       ++ stdenv.extraBuildInputs
       ++ concatLists dependencies);

  computedPropagatedSandboxProfile =
    concatMap (input: input.__propagatedSandboxProfile or [])
      (concatLists propagatedDependencies);

  computedImpureHostDeps =
    unique (concatMap (input: input.__propagatedImpureHostDeps or [])
      (stdenv.extraNativeBuildInputs
       ++ stdenv.extraBuildInputs
       ++ concatLists dependencies));

  computedPropagatedImpureHostDeps =
    unique (concatMap (input: input.__propagatedImpureHostDeps or [])
      (concatLists propagatedDependencies));

  envIsExportable = isAttrs env && !isDerivation env;

  derivationArg =
    (removeAttrs attrs
      (["meta" "passthru" "pos"
       "checkInputs" "installCheckInputs"
       "nativeCheckInputs" "nativeInstallCheckInputs"
       "__contentAddressed"
       "__darwinAllowLocalNetworking"
       "__impureHostDeps" "__propagatedImpureHostDeps"
       "sandboxProfile" "propagatedSandboxProfile"]
       ++ optional (__structuredAttrs || envIsExportable) "env"))
    // (optionalAttrs (attrs ? name || (attrs ? pname && attrs ? version)) {
      name =
        let
          # Indicate the host platform of the derivation if cross compiling.
          # Fixed-output derivations like source tarballs shouldn't get a host
          # suffix. But we have some weird ones with run-time deps that are
          # just used for their side-affects. Those might as well since the
          # hash can't be the same. See #32986.
          hostSuffix = optionalString
            (stdenv.hostPlatform != stdenv.buildPlatform && !dontAddHostSuffix)
            "-${stdenv.hostPlatform.config}";

          # Disambiguate statically built packages. This was originally
          # introduce as a means to prevent nix-env to get confused between
          # nix and nixStatic. This should be also achieved by moving the
          # hostSuffix before the version, so we could contemplate removing
          # it again.
          staticMarker = optionalString stdenv.hostPlatform.isStatic "-static";
        in
        lib.strings.sanitizeDerivationName (
          if attrs ? name
          then attrs.name + hostSuffix
          else
            # we cannot coerce null to a string below
            assert assertMsg (attrs ? version && attrs.version != null) "The ‘version’ attribute cannot be null.";
            "${attrs.pname}${staticMarker}${hostSuffix}-${attrs.version}"
        );
    }) // optionalAttrs __structuredAttrs { env = checkedEnv; } // {
      builder = attrs.realBuilder or stdenv.shell;
      args = attrs.args or ["-e" (attrs.builder or ./default-builder.sh)];
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
      inherit __structuredAttrs strictDeps;

      depsBuildBuild              = elemAt (elemAt dependencies 0) 0;
      nativeBuildInputs           = elemAt (elemAt dependencies 0) 1;
      depsBuildTarget             = elemAt (elemAt dependencies 0) 2;
      depsHostHost                = elemAt (elemAt dependencies 1) 0;
      buildInputs                 = elemAt (elemAt dependencies 1) 1;
      depsTargetTarget            = elemAt (elemAt dependencies 2) 0;

      depsBuildBuildPropagated    = elemAt (elemAt propagatedDependencies 0) 0;
      propagatedNativeBuildInputs = elemAt (elemAt propagatedDependencies 0) 1;
      depsBuildTargetPropagated   = elemAt (elemAt propagatedDependencies 0) 2;
      depsHostHostPropagated      = elemAt (elemAt propagatedDependencies 1) 0;
      propagatedBuildInputs       = elemAt (elemAt propagatedDependencies 1) 1;
      depsTargetTargetPropagated  = elemAt (elemAt propagatedDependencies 2) 0;

      # This parameter is sometimes a string, sometimes null, and sometimes a list, yuck
      configureFlags =
        configureFlags
        ++ optional (elem "build"  configurePlatforms) "--build=${stdenv.buildPlatform.config}"
        ++ optional (elem "host"   configurePlatforms) "--host=${stdenv.hostPlatform.config}"
        ++ optional (elem "target" configurePlatforms) "--target=${stdenv.targetPlatform.config}";

      cmakeFlags =
        cmakeFlags
        ++ optionals (stdenv.hostPlatform != stdenv.buildPlatform) ([
          "-DCMAKE_SYSTEM_NAME=${findFirst isString "Generic" (optional (!stdenv.hostPlatform.isRedox) stdenv.hostPlatform.uname.system)}"
        ] ++ optionals (stdenv.hostPlatform.uname.processor != null) [
          "-DCMAKE_SYSTEM_PROCESSOR=${stdenv.hostPlatform.uname.processor}"
        ] ++ optionals (stdenv.hostPlatform.uname.release != null) [
          "-DCMAKE_SYSTEM_VERSION=${stdenv.hostPlatform.uname.release}"
        ] ++ optionals (stdenv.hostPlatform.isDarwin) [
          "-DCMAKE_OSX_ARCHITECTURES=${stdenv.hostPlatform.darwinArch}"
        ] ++ optionals (stdenv.buildPlatform.uname.system != null) [
          "-DCMAKE_HOST_SYSTEM_NAME=${stdenv.buildPlatform.uname.system}"
        ] ++ optionals (stdenv.buildPlatform.uname.processor != null) [
          "-DCMAKE_HOST_SYSTEM_PROCESSOR=${stdenv.buildPlatform.uname.processor}"
        ] ++ optionals (stdenv.buildPlatform.uname.release != null) [
          "-DCMAKE_HOST_SYSTEM_VERSION=${stdenv.buildPlatform.uname.release}"
        ] ++ optionals (stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
          "-DCMAKE_CROSSCOMPILING_EMULATOR=env"
        ] ++ lib.optionals stdenv.hostPlatform.isStatic [
          "-DCMAKE_LINK_SEARCH_START_STATIC=ON"
        ]);

      mesonFlags =
        let
          # See https://mesonbuild.com/Reference-tables.html#cpu-families
          cpuFamily = platform: with platform;
            /**/ if isAarch32 then "arm"
            else if isx86_32  then "x86"
            else platform.uname.processor;

          crossFile = builtins.toFile "cross-file.conf" ''
            [properties]
            bindgen_clang_arguments = ['-target', '${stdenv.targetPlatform.config}']
            needs_exe_wrapper = ${boolToString (!stdenv.buildPlatform.canExecute stdenv.hostPlatform)}

            [host_machine]
            system = '${stdenv.targetPlatform.parsed.kernel.name}'
            cpu_family = '${cpuFamily stdenv.targetPlatform}'
            cpu = '${stdenv.targetPlatform.parsed.cpu.name}'
            endian = ${if stdenv.targetPlatform.isLittleEndian then "'little'" else "'big'"}

            [binaries]
            llvm-config = 'llvm-config-native'
            rust = ['rustc', '--target', '${stdenv.targetPlatform.rust.rustcTargetSpec}']
          '';
          crossFlags = optionals (stdenv.hostPlatform != stdenv.buildPlatform) [ "--cross-file=${crossFile}" ];
        in crossFlags ++ mesonFlags;

      inherit patches;

      inherit doCheck doInstallCheck;

      inherit outputs;
    } // optionalAttrs (__contentAddressed) {
      inherit __contentAddressed;
      # Provide default values for outputHashMode and outputHashAlgo because
      # most people won't care about these anyways
      outputHashAlgo = attrs.outputHashAlgo or "sha256";
      outputHashMode = attrs.outputHashMode or "recursive";
    } // optionalAttrs (enableParallelBuilding) {
      inherit enableParallelBuilding;
      enableParallelChecking = attrs.enableParallelChecking or true;
      enableParallelInstalling = attrs.enableParallelInstalling or true;
    } // optionalAttrs (hardeningDisable != [] || hardeningEnable != [] || stdenv.hostPlatform.isMusl) {
      NIX_HARDENING_ENABLE = enabledHardeningOptions;
    } // optionalAttrs (stdenv.hostPlatform.isx86_64 && stdenv.hostPlatform ? gcc.arch) {
      requiredSystemFeatures = attrs.requiredSystemFeatures or [] ++ [ "gccarch-${stdenv.hostPlatform.gcc.arch}" ];
    } // optionalAttrs (stdenv.buildPlatform.isDarwin) {
      inherit __darwinAllowLocalNetworking;
      # TODO: remove `unique` once nix has a list canonicalization primitive
      __sandboxProfile =
      let profiles = [ stdenv.extraSandboxProfile ] ++ computedSandboxProfile ++ computedPropagatedSandboxProfile ++ [ propagatedSandboxProfile sandboxProfile ];
          final = concatStringsSep "\n" (filter (x: x != "") (unique profiles));
      in final;
      __propagatedSandboxProfile = unique (computedPropagatedSandboxProfile ++ [ propagatedSandboxProfile ]);
      __impureHostDeps = computedImpureHostDeps ++ computedPropagatedImpureHostDeps ++ __propagatedImpureHostDeps ++ __impureHostDeps ++ stdenv.__extraImpureHostDeps ++ [
        "/dev/zero"
        "/dev/random"
        "/dev/urandom"
        "/bin/sh"
      ];
      __propagatedImpureHostDeps = computedPropagatedImpureHostDeps ++ __propagatedImpureHostDeps;
    } //
    # If we use derivations directly here, they end up as build-time dependencies.
    # This is especially problematic in the case of disallowed*, since the disallowed
    # derivations will be built by nix as build-time dependencies, while those
    # derivations might take a very long time to build, or might not even build
    # successfully on the platform used.
    # We can improve on this situation by instead passing only the outPath,
    # without an attached string context, to nix. The out path will be a placeholder
    # which will be replaced by the actual out path if the derivation in question
    # is part of the final closure (and thus needs to be built). If it is not
    # part of the final closure, then the placeholder will be passed along,
    # but in that case we know for a fact that the derivation is not part of the closure.
    # This means that passing the out path to nix does the right thing in either
    # case, both for disallowed and allowed references/requisites, and we won't
    # build the derivation if it wouldn't be part of the closure, saving time and resources.
    # While the problem is less severe for allowed*, since we want the derivation
    # to be built eventually, we would still like to get the error early and without
    # having to wait while nix builds a derivation that might not be used.
    # See also https://github.com/NixOS/nix/issues/4629
    optionalAttrs (attrs ? disallowedReferences) {
      disallowedReferences =
        map unsafeDerivationToUntrackedOutpath attrs.disallowedReferences;
    } //
    optionalAttrs (attrs ? disallowedRequisites) {
      disallowedRequisites =
        map unsafeDerivationToUntrackedOutpath attrs.disallowedRequisites;
    } //
    optionalAttrs (attrs ? allowedReferences) {
      allowedReferences =
        mapNullable unsafeDerivationToUntrackedOutpath attrs.allowedReferences;
    } //
    optionalAttrs (attrs ? allowedRequisites) {
      allowedRequisites =
        mapNullable unsafeDerivationToUntrackedOutpath attrs.allowedRequisites;
    };

  meta = checkMeta.commonMeta { inherit validity attrs pos references; };
  validity = checkMeta.assertValidity { inherit meta attrs; };

  checkedEnv =
    let
      overlappingNames = attrNames (builtins.intersectAttrs env derivationArg);
    in
    assert assertMsg envIsExportable
      "When using structured attributes, `env` must be an attribute set of environment variables.";
    assert assertMsg (overlappingNames == [ ])
      "The ‘env’ attribute set cannot contain any attributes passed to derivation. The following attributes are overlapping: ${concatStringsSep ", " overlappingNames}";
    mapAttrs
      (n: v: assert assertMsg (isString v || isBool v || isInt v || isDerivation v)
        "The ‘env’ attribute set can only contain derivation, string, boolean or integer attributes. The ‘${n}’ attribute is of type ${builtins.typeOf v}."; v)
      env;

in

extendDerivation
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
       args = [ "-c" ''
         export > $out
         for var in $passAsFile; do
             pathVar="''${var}Path"
             printf "%s" "$(< "''${!pathVar}")" >> $out
         done
       '' ];

       # inputDerivation produces the inputs; not the outputs, so any
       # restrictions on what used to be the outputs don't serve a purpose
       # anymore.
       allowedReferences = null;
       allowedRequisites = null;
       disallowedReferences = [ ];
       disallowedRequisites = [ ];
     });

     inherit passthru overrideAttrs;
     inherit meta;
   } //
   # Pass through extra attributes that are not inputs, but
   # should be made available to Nix expressions using the
   # derivation (e.g., in assertions).
   passthru)
  (derivation (derivationArg // optionalAttrs envIsExportable checkedEnv));

in
  fnOrAttrs:
    if builtins.isFunction fnOrAttrs
    then makeDerivationExtensible fnOrAttrs
    else makeDerivationExtensibleConst fnOrAttrs
