{ lib, config, stdenv }:

rec {
  # `mkDerivation` wraps the builtin `derivation` function to
  # produce derivations that use this stdenv and its shell.
  #
  # See also:
  #
  # * https://nixos.org/nixpkgs/manual/#sec-using-stdenv
  #   Details on how to use this mkDerivation function
  #
  # * https://nixos.org/nix/manual/#ssec-derivation
  #   Explanation about derivations in general
  mkDerivation =
    { name ? ""

    , nativeBuildInputs ? []
    , buildInputs ? []

    , propagatedNativeBuildInputs ? []
    , propagatedBuildInputs ? []

    , configureFlags ? []
    , # Target is not included by default because most programs don't care.
      # Including it then would cause needless mass rebuilds.
      #
      # TODO(@Ericson2314): Make [ "build" "host" ] always the default.
      configurePlatforms ? lib.optionals
        (stdenv.hostPlatform != stdenv.buildPlatform)
        [ "build" "host" ]
    , crossConfig ? null
    , meta ? {}
    , passthru ? {}
    , pos ? # position used in error messages and for meta.position
        (if attrs.meta.description or null != null
          then builtins.unsafeGetAttrPos "description" attrs.meta
          else builtins.unsafeGetAttrPos "name" attrs)
    , separateDebugInfo ? false
    , outputs ? [ "out" ]
    , __impureHostDeps ? []
    , __propagatedImpureHostDeps ? []
    , sandboxProfile ? ""
    , propagatedSandboxProfile ? ""
    , ... } @ attrs:
    let
      dependencies = map lib.chooseDevOutputs [
        (map (drv: drv.nativeDrv or drv) nativeBuildInputs
           ++ lib.optional separateDebugInfo ../../build-support/setup-hooks/separate-debug-info.sh
           ++ lib.optional stdenv.hostPlatform.isWindows ../../build-support/setup-hooks/win-dll-link.sh)
        (map (drv: drv.crossDrv or drv) buildInputs)
      ];
      propagatedDependencies = map lib.chooseDevOutputs [
        (map (drv: drv.nativeDrv or drv) propagatedNativeBuildInputs)
        (map (drv: drv.crossDrv or drv) propagatedBuildInputs)
      ];

      outputs' =
        outputs ++
        (if separateDebugInfo then assert stdenv.hostPlatform.isLinux; [ "debug" ] else []);

      derivationArg =
        (removeAttrs attrs
          ["meta" "passthru" "crossAttrs" "pos"
           "__impureHostDeps" "__propagatedImpureHostDeps"
           "sandboxProfile" "propagatedSandboxProfile"])
        // (let
          computedSandboxProfile =
            lib.concatMap (input: input.__propagatedSandboxProfile or []) (stdenv.extraBuildInputs ++ lib.concatLists dependencies);
          computedPropagatedSandboxProfile =
            lib.concatMap (input: input.__propagatedSandboxProfile or []) (lib.concatLists propagatedDependencies);
          computedImpureHostDeps =
            lib.unique (lib.concatMap (input: input.__propagatedImpureHostDeps or []) (stdenv.extraBuildInputs ++ lib.concatLists dependencies));
          computedPropagatedImpureHostDeps =
            lib.unique (lib.concatMap (input: input.__propagatedImpureHostDeps or []) (lib.concatLists propagatedDependencies));
        in
        {
          name = name + lib.optionalString
            (stdenv.hostPlatform != stdenv.buildPlatform)
            stdenv.hostPlatform.config;
          builder = attrs.realBuilder or stdenv.shell;
          args = attrs.args or ["-e" (attrs.builder or ./default-builder.sh)];
          inherit stdenv;
          inherit (stdenv) system;
          userHook = config.stdenv.userHook or null;
          __ignoreNulls = true;

          nativeBuildInputs = lib.elemAt dependencies 0;
          buildInputs = lib.elemAt dependencies 1;

          propagatedNativeBuildInputs = lib.elemAt propagatedDependencies 0;
          propagatedBuildInputs = lib.elemAt propagatedDependencies 1;

          # This parameter is sometimes a string, sometimes null, and sometimes a list, yuck
          configureFlags = let inherit (lib) optional elem; in
            (/**/ if lib.isString configureFlags then [configureFlags]
             else if configureFlags == null      then []
             else                                     configureFlags)
            ++ optional (elem "build"  configurePlatforms) "--build=${stdenv.buildPlatform.config}"
            ++ optional (elem "host"   configurePlatforms) "--host=${stdenv.hostPlatform.config}"
            ++ optional (elem "target" configurePlatforms) "--target=${stdenv.targetPlatform.config}";

        } // lib.optionalAttrs (stdenv.buildPlatform.isDarwin) {
          # TODO: remove lib.unique once nix has a list canonicalization primitive
          __sandboxProfile =
          let profiles = [ stdenv.extraSandboxProfile ] ++ computedSandboxProfile ++ computedPropagatedSandboxProfile ++ [ propagatedSandboxProfile sandboxProfile ];
              final = lib.concatStringsSep "\n" (lib.filter (x: x != "") (lib.unique profiles));
          in final;
          __propagatedSandboxProfile = lib.unique (computedPropagatedSandboxProfile ++ [ propagatedSandboxProfile ]);
          __impureHostDeps = computedImpureHostDeps ++ computedPropagatedImpureHostDeps ++ __propagatedImpureHostDeps ++ __impureHostDeps ++ stdenv.__extraImpureHostDeps ++ [
            "/dev/zero"
            "/dev/random"
            "/dev/urandom"
            "/bin/sh"
          ];
          __propagatedImpureHostDeps = computedPropagatedImpureHostDeps ++ __propagatedImpureHostDeps;
        } // (if outputs' != [ "out" ] then {
          outputs = outputs';
        } else { }));

      # The meta attribute is passed in the resulting attribute set,
      # but it's not part of the actual derivation, i.e., it's not
      # passed to the builder and is not a dependency.  But since we
      # include it in the result, it *is* available to nix-env for queries.
      meta = { }
          # If the packager hasn't specified `outputsToInstall`, choose a default,
          # which is the name of `p.bin or p.out or p`;
          # if he has specified it, it will be overridden below in `// meta`.
          #   Note: This default probably shouldn't be globally configurable.
          #   Services and users should specify outputs explicitly,
          #   unless they are comfortable with this default.
        // { outputsToInstall =
          let
            outs = outputs'; # the value passed to derivation primitive
            hasOutput = out: builtins.elem out outs;
          in [( lib.findFirst hasOutput null (["bin" "out"] ++ outs) )];
        }
        // attrs.meta or {}
          # Fill `meta.position` to identify the source location of the package.
        // lib.optionalAttrs (pos != null)
          { position = pos.file + ":" + toString pos.line; }
        ;

    in

      lib.addPassthru
        (derivation (import ./check-meta.nix
          {
            inherit lib config meta derivationArg;
            mkDerivationArg = attrs;
            # Nix itself uses the `system` field of a derivation to decide where
            # to build it. This is a bit confusing for cross compilation.
            inherit (stdenv) system;
          }))
        ( {
            overrideAttrs = f: mkDerivation (attrs // (f attrs));
            inherit meta passthru;
          } //
          # Pass through extra attributes that are not inputs, but
          # should be made available to Nix expressions using the
          # derivation (e.g., in assertions).
          passthru);
}
