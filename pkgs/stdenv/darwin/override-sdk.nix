# The basic algorithm is to rewrite the propagated inputs of a package and any of its
# own propagated inputs recursively to replace references from the default SDK with
# those from the requested SDK version. This is done across all propagated inputs to
# avoid making assumptions about how those inputs are being used.
#
# For example, packages may propagate target-target dependencies with the expectation that
# they will be just build inputs when the package itself is used as a native build input.
#
# To support this use case and operate without regard to the original package set,
# `overrideSDK` creates a mapping from the default SDK in all package categories to the
# requested SDK. If the lookup fails, it is assumed the package is not part of the SDK.
# Non-SDK packages are processed per the algorithm described above.
{
  lib,
  extendMkDerivationArgs,
  pkgsBuildBuild,
  pkgsBuildHost,
  pkgsBuildTarget,
  pkgsHostHost,
  pkgsHostTarget,
  pkgsTargetTarget,
}@args:

let
  # Takes a mapping from a package to its replacement and transforms it into a list of
  # mappings by output (e.g., a package with three outputs produces a list of size 3).
  expandOutputs =
    mapping:
    map (output: {
      key = builtins.unsafeDiscardStringContext (lib.getOutput output mapping.original);
      replacement = lib.getOutput output mapping.replacement;
    }) mapping.original.outputs;

  # Produces a list of mappings from an SDK path specified by `attr` in the given
  # package set and SDK version.
  mkMapping =
    attr: pkgs: sdk:
    lib.foldlAttrs (
      mappings: name: pkg:
      let
        # Avoid evaluation failures due to missing or throwing
        # frameworks (such as QuickTime in the 11.0 SDK).
        maybeReplacement = builtins.tryEval sdk.${attr}.${name} or { success = false; };
      in
      if maybeReplacement.success then
        mappings
        ++ expandOutputs {
          original = pkg;
          replacement = maybeReplacement.value;
        }
      else
        mappings
    ) [ ] pkgs.darwin.apple_sdk.${attr};

  # Produces a list of overrides for the given package set and SDK Version.
  # If you want to manually specify a mapping, this is where you should do it.
  mkOverrides =
    pkgs: sdk: version:
    lib.concatMap expandOutputs [
      # Libsystem needs to match the one used by the SDK or weird errors happen.
      {
        original = pkgs.darwin.apple_sdk.Libsystem;
        replacement = sdk.Libsystem;
      }
      # Make sure darwin.CF is mapped to the correct version for the SDK.
      {
        original = pkgs.darwin.CF;
        replacement = sdk.frameworks.CoreFoundation;
      }
      # libobjc needs to be handled specially because it’s not actually in the SDK.
      {
        original = pkgs.darwin.libobjc;
        replacement = sdk.objc4;
      }
      # Unfortunately, this is not consistent between Darwin SDKs in nixpkgs, so
      # try both versions to map between them.
      {
        original = pkgs.darwin.apple_sdk.sdk or pkgs.darwin.apple_sdk.MacOSX-SDK;
        replacement = sdk.sdk or sdk.MacOSX-SDK;
      }
      # Remap the SDK root. This is used by clang to set the SDK version when
      # linking. This behavior is automatic by clang and can’t be overriden.
      # Otherwise, without the SDK root set, the SDK version will be inferred to
      # be the same as the deployment target, which is not usually what you want.
      {
        original = pkgs.darwin.apple_sdk.sdkRoot;
        replacement = sdk.sdkRoot;
      }
      # Override xcodebuild because it hardcodes the SDK version.
      # TODO: Make xcodebuild defer to the SDK root set in the stdenv.
      {
        original = pkgs.xcodebuild;
        replacement = pkgs.xcodebuild.override {
          # Do the override manually to avoid an infinite recursion.
          stdenv = pkgs.stdenv.override (old: {
            buildPlatform = mkPlatform version old.buildPlatform;
            hostPlatform = mkPlatform version old.hostPlatform;
            targetPlatform = mkPlatform version old.targetPlatform;

            allowedRequisites = null;
            cc = mkCC sdk.Libsystem old.cc;
          });
        };
      }
    ];

  mkBintools =
    Libsystem: bintools:
    if bintools ? override then
      bintools.override { libc = Libsystem; }
    else
      let
        # `override` isn’t available, so bintools has to be rewrapped with the new libc.
        # Most of the required arguments can be recovered except for `postLinkSignHook`
        # and `signingUtils`, which have to be scrapped from the original’s `postFixup`.
        # This isn’t ideal, but it works.
        postFixup = lib.splitString "\n" bintools.postFixup;

        postLinkSignHook = lib.pipe postFixup [
          (lib.findFirst (lib.hasPrefix "echo 'source") null)
          (builtins.match "^echo 'source (.*-post-link-sign-hook)' >> \\$out/nix-support/post-link-hook$")
          lib.head
        ];

        signingUtils = lib.pipe postFixup [
          (lib.findFirst (lib.hasPrefix "export signingUtils") null)
          (builtins.match "^export signingUtils=(.*)$")
          lib.head
        ];

        newBintools = pkgsBuildTarget.wrapBintoolsWith {
          inherit (bintools) name;

          buildPackages = { };
          libc = Libsystem;

          inherit lib;

          coreutils = bintools.coreutils_bin;
          gnugrep = bintools.gnugrep_bin;

          inherit (bintools) bintools;

          inherit postLinkSignHook signingUtils;
        };
      in
      lib.getOutput bintools.outputName newBintools;

  mkCC =
    Libsystem: cc:
    if cc ? override then
      cc.override {
        bintools = mkBintools Libsystem cc.bintools;
        libc = Libsystem;
      }
    else
      builtins.throw "CC has no override: ${cc}";

  mkPlatform =
    version: platform:
    platform
    // lib.optionalAttrs platform.isDarwin { inherit (version) darwinMinVersion darwinSdkVersion; };

  # Creates a stub package. Unchanged files from the original package are symlinked
  # into the package. The contents of `nix-support` are updated to reference any
  # replaced packages.
  #
  # Note: `env` is an attrset containing `outputs` and `dependencies`.
  # `dependencies` is a regex passed to sed and must be `passAsFile`.
  mkStub =
    name: env:
    pkgsHostTarget.runCommand name env (
      # Map over the outputs in the package being replaced to make sure the proxy is
      # a fully functional replacement. This is like `symlinkJoin` except for
      # outputs and the contents of `nix-support`, which will be customized.
      ''
        for outputName in $outputs; do
          mkdir -p "''${!outputName}"

          for targetPath in "''${!outputName}"/*; do
            targetName=$(basename "$targetPath")

            # `nix-support` is special-cased because any propagated inputs need their
            # SDK frameworks replaced with those from the requested SDK.
            if [ "$targetName" == "nix-support" ]; then
              mkdir "''${!outputName}/nix-support"

              for file in "$targetPath"/*; do
                fileName=$(basename "$file")
                targetFile="''${!outputName}/nix-support/$fileName"

                sed -f "$dependenciesPath" < "$file" > "$targetFile"
                if cmp -s "$file" "$targetFile"; then
                  rm "$targetFile"
                  ln -s "$file" "$targetFile"
                fi
              done
            else
              ln -s "$targetPath" "''${!outputName}/$targetName"
            fi
          done
        done
      '');

  # Looks up the replacement for `pkg` in the `newPackages` mapping. If `pkg` is a
  # compiler (meaning it has a `libc` attribute), the compiler will be overriden.
  getReplacement =
    newPackages: pkg:
    let
      pkgOrCC =
        if pkg.libc or null != null then
          # Heuristic to determine whether package is a compiler or bintools.
          if pkg.wrapperName == "CC_WRAPPER" then
            mkCC (getReplacement newPackages pkg.libc) pkg
          else
            mkBintools (getReplacement newPackages pkg.libc) pkg
        else
          pkg;
    in
    if lib.isDerivation pkg then
      newPackages.${builtins.unsafeDiscardStringContext pkg} or pkgOrCC
    else
      pkg;

  # Replaces all packages propagated by `pkgs` using the `newPackages` mapping.
  # It is assumed that all possible overrides have already been incorporated into
  # the mapping. If any propagated packages are replaced, a stub package will be
  # created with references to the old packages replaced in `nix-support`.
  replacePropagatedPackages =
    newPackages: pkg:
    let
      propagatedInputs = getPropagatedInputs pkg;
      env = {
        inherit (pkg) outputs;

        # Old dependencies are replaced with new ones via a sed script. It is assumed
        # that `|` will not appear in a store path.
        dependencies = lib.concatMapStrings (
          dep:
          let
            replacement = getReplacement newPackages dep;
          in
          lib.optionalString (dep != replacement) "s|${lib.escapeRegex dep.outPath}|${lib.escapeRegex replacement.outPath}|g;"
        ) propagatedInputs;

        passAsFile = [ "dependencies" ];
      };
    in
    # Only remap the package’s propagated inputs if there are any and if any of them
    # had packages remapped (with frameworks or proxy packages).
    if propagatedInputs != [ ] && env.dependencies != "" then mkStub pkg.name env else pkg;

  # Gets all propagated inputs in a package. This does not recurse.
  getPropagatedInputs =
    pkg:
    lib.optionals (lib.isDerivation pkg) (
      lib.concatMap (input: pkg.${input} or [ ]) [
        "depsBuildBuildPropagated"
        "propagatedNativeBuildInputs"
        "depsBuildTargetPropagated"
        "depsHostHostPropagated"
        "propagatedBuildInputs"
        "depsTargetTargetPropagated"
      ]
    );

  # Gets all propagated dependencies in a package.
  getPropagatedDependencies =
    pkgs:
    let
      mapToPropagatedInputs =
        pkgs:
        lib.pipe pkgs [
          (lib.filter (pkg: pkg != null))
          (map (pkg: {
            key = builtins.unsafeDiscardStringContext pkg;
            package = pkg;
            deps = getPropagatedInputs pkg;
          }))
        ];
    in
    lib.genericClosure {
      startSet = mapToPropagatedInputs pkgs;
      operator = { deps, ... }: mapToPropagatedInputs deps;
    };

  # Returns a package mapping based on remapping all propagated packages.
  #
  # Implementation note: recursion is avoided because it is costly. Instead, a flat
  # list of dependencies is obtained then sorted topologically, so that dependencies
  # can be updated in order (and only once). This produces a new mapping that must
  # be used to perform the actual updates to the propagated packages.
  getPackageMapping =
    baseMapping: input:
    let
      dependencies = lib.pipe input [
        getPropagatedDependencies
        (lib.toposort (x: y: lib.any (z: x.package == z) y.deps))
        (lib.getAttr "result")
        lib.reverseList
      ];
    in
    lib.foldl' (
      newPackages: pkg:
      let
        replacement = replacePropagatedPackages newPackages pkg.package;
        outPath = builtins.unsafeDiscardStringContext pkg.key;
      in
      if pkg.key == null || newPackages ? ${outPath} then
        newPackages
      else
        newPackages // { ${outPath} = replacement; }
    ) baseMapping dependencies;

  overrideSDK =
    stdenv: sdkVersion:
    let
      newVersion = {
        inherit (stdenv.hostPlatform) darwinMinVersion darwinSdkVersion;
      } // (if lib.isAttrs sdkVersion then sdkVersion else { darwinSdkVersion = sdkVersion; });

      inherit (newVersion) darwinMinVersion darwinSdkVersion;

      # Used to get an SDK version corresponding to the requested `darwinSdkVersion`.
      # TODO: Treat `darwinSdkVersion` as a constraint rather than as an exact version.
      resolveSDK = pkgs: pkgs.darwin."apple_sdk_${lib.replaceStrings [ "." ] [ "_" ] darwinSdkVersion}";

      # `newSdkPackages` is constructed based on the assumption that SDK packages only
      # propagate versioned packages from that SDK -- that they neither propagate
      # unversioned SDK packages nor propagate non-SDK packages (such as curl).
      #
      # Note: `builtins.unsafeDiscardStringContext` is used to allow the path from the
      # original package output to be mapped to the replacement. This is safe because
      # the value is not persisted anywhere and necessary because store paths are not
      # allowed as attrset names otherwise.
      baseSdkMapping =
        let
          sdkPackages = lib.genericClosure {
            startSet = lib.pipe args [
              (lib.flip removeAttrs [
                "lib"
                "extendMkDerivationArgs"
              ])
              (lib.filterAttrs (_: lib.hasAttr "darwin"))
              (lib.mapAttrs (
                name: value: {
                  key = name;
                  inherit value;
                }
              ))
              lib.attrValues
            ];
            operator =
              item:
              let
                newSDK = resolveSDK item.value;
              in
              if item ? replacement then
                [ ]
              else if item ? replacementList then
                item.replacementList
              else
                [
                  {
                    key = "frameworks";
                    replacementList = mkMapping "frameworks" item.value newSDK;
                  }
                  {
                    key = "libs";
                    pkgs = mkMapping "libs" item.value newSDK;
                  }
                  {
                    key = "overrides";
                    replacementList = mkOverrides item.value newSDK newVersion;
                  }
                ];
          };
        in
        lib.pipe sdkPackages [
          (lib.filter (attrs: attrs ? replacement))
          (map (
            { key, replacement }:
            {
              name = key;
              value = replacement;
            }
          ))
          lib.listToAttrs
        ];

      # Remaps all inputs given to the requested SDK version. The result is an attrset
      # that can be passed to `extendMkDerivationArgs`.
      mapInputsToSDK =
        inputs: args:
        lib.pipe inputs [
          (lib.filter (input: args ? ${input}))
          (lib.flip lib.genAttrs (
            inputName:
            let
              input = args.${inputName};
              newPackages = getPackageMapping baseSdkMapping input;
            in
            map (getReplacement newPackages) input
          ))
        ];
    in
    stdenv.override (
      old:
      {
        buildPlatform = mkPlatform newVersion old.buildPlatform;
        hostPlatform = mkPlatform newVersion old.hostPlatform;
        targetPlatform = mkPlatform newVersion old.targetPlatform;
      }
      # Only perform replacements if the SDK version has changed. Changing only the
      # deployment target does not require replacing the libc or SDK dependencies.
      // lib.optionalAttrs (old.hostPlatform.darwinSdkVersion != darwinSdkVersion) {
        allowedRequisites = null;

        mkDerivationFromStdenv = extendMkDerivationArgs old (mapInputsToSDK [
          "depsBuildBuild"
          "nativeBuildInputs"
          "depsBuildTarget"
          "depsHostHost"
          "buildInputs"
          "depsTargetTarget"
          "depsBuildBuildPropagated"
          "propagatedNativeBuildInputs"
          "depsBuildTargetPropagated"
          "depsHostHostPropagated"
          "propagatedBuildInputs"
          "depsTargetTargetPropagated"
        ]);

        cc = getReplacement baseSdkMapping old.cc;

        extraBuildInputs = map (getReplacement baseSdkMapping) stdenv.extraBuildInputs;
        extraNativeBuildInputs = map (getReplacement baseSdkMapping) stdenv.extraNativeBuildInputs;
      }
    );
in
overrideSDK
