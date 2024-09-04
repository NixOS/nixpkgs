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
  stdenvNoCC,
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
      name = builtins.unsafeDiscardStringContext (lib.getOutput output mapping.original);
      value = lib.getOutput output mapping.replacement;
    }) mapping.original.outputs;

  # Produces a list of mappings from the default SDK to the new SDK (`sdk`).
  # `attr` indicates which SDK path to remap (e.g., `libs` remaps `apple_sdk.libs`).
  #
  # TODO: Update once the SDKs have been refactored to a common pattern to better handle
  # frameworks that are not present in both SDKs. Currently, they’re dropped.
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

  # Produces a list of overrides for the given package set, SDK, and version.
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
  mkProxyPackage =
    name: env:
    stdenvNoCC.mkDerivation {
      inherit name;

      inherit (env) outputs replacements sourceOutputs;

      # Take advantage of the fact that replacements and sourceOutputs will be passed
      # via JSON and parsed into environment variables.
      __structuredAttrs = true;

      buildCommand = ''
        # Map over the outputs in the package being replaced to make sure the proxy is
        # a fully functional replacement. This is like `symlinkJoin` except for
        # outputs and the contents of `nix-support`, which will be customized.
        function replacePropagatedInputs() {
          local sourcePath=$1
          local targetPath=$2

          mkdir -p "$targetPath"

          local sourceFile
          for sourceFile in "$sourcePath"/*; do
            local fileName=$(basename "$sourceFile")
            local targetFile="$targetPath/$fileName"

            if [ -d "$sourceFile" ]; then
              replacePropagatedInputs "$sourceFile" "$targetPath/$fileName"
              # Check to see if any of the files in the folder were replaced.
              # Otherwise, replace the folder with a symlink if none were changed.
              if [ "$(find -maxdepth 1 "$targetPath/$fileName" -not -type l)" = "" ]; then
                rm "$targetPath/$fileName"/*
                ln -s "$sourceFile" "$targetPath/$fileName"
              fi
            else
              cp "$sourceFile" "$targetFile"
              local original
              for original in "''${!replacements[@]}"; do
                substituteInPlace "$targetFile" \
                  --replace-quiet "$original" "''${replacements[$original]}"
              done
              if cmp -s "$sourceFile" "$targetFile"; then
                rm "$targetFile"
                ln -s "$sourceFile" "$targetFile"
              fi
            fi
          done
        }

        local outputName
        for outputName in "''${!outputs[@]}"; do
          local outPath=''${outputs[$outputName]}
          mkdir -p "$outPath"

          local sourcePath
          for sourcePath in "''${sourceOutputs[$outputName]}"/*; do
            sourceName=$(basename "$sourcePath")
            # `nix-support` is special-cased because any propagated inputs need their
            # SDK frameworks replaced with those from the requested SDK.
            if [ "$sourceName" == "nix-support" ]; then
              replacePropagatedInputs "$sourcePath" "$outPath/nix-support"
            else
              ln -s "$sourcePath" "$outPath/$sourceName"
            fi
          done
        done
      '';
    };

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
  # the mapping. If any propagated packages are replaced, a proxy package will be
  # created with references to the old packages replaced in `nix-support`.
  replacePropagatedPackages =
    newPackages: pkg:
    let
      propagatedInputs = getPropagatedInputs pkg;
      env = {
        inherit (pkg) outputs;

        replacements = lib.pipe propagatedInputs [
          (lib.filter (pkg: pkg != null))
          lib.flatten
          (map (dep: {
            name = builtins.unsafeDiscardStringContext dep;
            value = getReplacement newPackages dep;
          }))
          (lib.filter (mapping: mapping.name != mapping.value))
          lib.listToAttrs
        ];

        sourceOutputs = lib.genAttrs pkg.outputs (output: lib.getOutput output pkg);
      };
    in
    # Only remap the package’s propagated inputs if there are any and if any of them
    # had packages remapped (with frameworks or proxy packages).
    if propagatedInputs != [ ] && env.replacements != { } then mkProxyPackage pkg.name env else pkg;

  # Gets all propagated dependencies in a package in reverse order sorted topologically.
  # This takes advantage of the fact that items produced by `operator` are pushed to
  # the end of the working set, ensuring that dependencies always appear after their
  # parent in the list with leaf nodes at the end.
  topologicallyOrderedPropagatedDependencies =
    pkgs:
    let
      mapPackageDeps = lib.flip lib.pipe [
        (lib.filter (pkg: pkg != null))
        lib.flatten
        (map (pkg: {
          key = builtins.unsafeDiscardStringContext pkg;
          package = pkg;
          deps = getPropagatedInputs pkg;
        }))
      ];
    in
    lib.genericClosure {
      startSet = mapPackageDeps pkgs;
      operator = { deps, ... }: mapPackageDeps deps;
    };

  # Returns a package mapping based on remapping all propagated packages.
  getPackageMapping =
    baseMapping: input:
    let
      dependencies = topologicallyOrderedPropagatedDependencies input;
    in
    lib.foldr (
      pkg: newPackages:
      let
        replacement = replacePropagatedPackages newPackages pkg.package;
        outPath = pkg.key;
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
      baseSdkMapping = lib.pipe args [
        (lib.flip removeAttrs [
          "lib"
          "stdenvNoCC"
          "extendMkDerivationArgs"
        ])
        (lib.filterAttrs (_: lib.hasAttr "darwin"))
        lib.attrValues
        (lib.concatMap (
          pkgs:
          let
            newSDK = resolveSDK pkgs;

            frameworks = mkMapping "frameworks" pkgs newSDK;
            libs = mkMapping "libs" pkgs newSDK;
            overrides = mkOverrides pkgs newSDK newVersion;
          in
          frameworks ++ libs ++ overrides
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
        buildPlatform = mkPlatform newVersion stdenv.buildPlatform;
        hostPlatform = mkPlatform newVersion stdenv.hostPlatform;
        targetPlatform = mkPlatform newVersion stdenv.targetPlatform;
      }
      # Only perform replacements if the SDK version has changed. Changing only the
      # deployment target does not require replacing the libc or SDK dependencies.
      // lib.optionalAttrs (stdenv.hostPlatform.darwinSdkVersion != darwinSdkVersion) {
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
