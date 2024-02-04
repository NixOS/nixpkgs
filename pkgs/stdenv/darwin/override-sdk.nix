# The basic algorithm is to rewrite the propagated inputs of a package and any of its
# own propagated inputs recurssively to replace references from the default SDK with
# those from the requested SDK version. This is done across all propagated inputs to
# avoid making assumptions about how those inputs are being used.
#
# For example, packages may propgate target-target dependencies with the expectation that
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
  overrideSDK =
    stdenv: sdkVersion:
    let
      inherit
        (
          {
            inherit (stdenv.hostPlatform) darwinMinVersion darwinSdkVersion;
          }
          // (if lib.isAttrs sdkVersion then sdkVersion else { darwinSdkVersion = sdkVersion; })
        )
        darwinMinVersion
        darwinSdkVersion
        ;

      resolveSDK =
        pkgs:
        # TODO: Treat `darwinSdkVersion` as a constraint rather than as an exact version.
        pkgs.darwin."apple_sdk_${lib.replaceStrings [ "." ] [ "_" ] darwinSdkVersion}";

      mkMapping =
        attr: pkgs: sdk:
        lib.pipe pkgs.darwin.apple_sdk."${attr}" [
          lib.attrsToList
          (map (
            pkg:
            let
              # Avoid evaluation failures due to missing or throwing
              # frameworks (such as QuickTime in the 11.0 SDK).
              replacement = builtins.tryEval sdk."${attr}"."${pkg.name}" or { success = false; };
            in
            if replacement.success then
              {
                original = pkg.value;
                replacement = replacement.value;
              }
            else
              false
          ))
          (lib.filter (x: x != false))
        ];

      uniqueBy =
        proj: lib.foldl' (acc: e: if lib.any (x: proj e == proj x) acc then acc else acc ++ [ e ]) [ ];

      # `newSdkPackages` is constructed based on the assumption that SDK packages only
      # propagate versioned packages from that SDK -- that they neither propagate
      # unversioned packages SDK packages nor propagate non-SDK packages (such as curl).
      newSdkPackages = lib.pipe args [
        (lib.flip removeAttrs [
          "lib"
          "extendMkDerivationArgs"
        ])
        lib.attrValues
        (lib.filter (lib.hasAttr "darwin"))
        (uniqueBy (lib.getAttr "stdenv"))
        (lib.concatMap (
          pkgs:
          let
            newSDK = resolveSDK pkgs;
          in
          mkMapping "frameworks" pkgs newSDK
          ++ mkMapping "libs" pkgs newSDK
          # Manual overrides for darwin.Libsystem, darwin.libobjc, darwin.sdk, and xcodebuild.
          ++ [
            # Libsystem needs to match the one used by the SDK or weird errors happen.
            {
              original = pkgs.darwin.apple_sdk.Libsystem;
              replacement = newSDK.Libsystem;
            }
            # Make sure darwin.CF is mapped to the correct version for the SDK.
            {
              original = pkgs.darwin.CF;
              replacement = newSDK.frameworks.CoreFoundation;
            }
            # libobjc needs to be handled specially because it’s not actually in the SDK.
            {
              original = pkgs.darwin.libobjc;
              replacement = newSDK.objc4;
            }
            # Unfortunately, this is not consistent between Dariwn SDKs in nixpkgs, so
            # try both versions to map between them.
            {
              original = pkgs.darwin.apple_sdk.sdk or pkgs.darwin.apple_sdk.MacOSX-SDK;
              replacement = newSDK.sdk or newSDK.MacOSX-SDK;
            }
            # Remap the SDK root. This is used by clang to set the SDK version when
            # linking. This behavior is automatic by clang and can’t be overriden.
            # Otherwise, without the SDK root set, the SDK version will be inferred to
            # be the same as the deployment target, which is not usually what you want.
            {
              original = pkgs.darwin.apple_sdk.sdkRoot;
              replacement = newSDK.sdkRoot;
            }
            # Override xcodebuild because it hardcodes the SDK version.
            # TODO: Make xcodebuild defer to the SDK root set in the stdenv.
            {
              original = pkgs.xcodebuild;
              replacement = pkgs.xcodebuild.override {
                # Do the override manually to avoid an infinite recursion.
                stdenv = pkgs.stdenv.override (old: {
                  buildPlatform = mkPlatform old.buildPlatform;
                  hostPlatform = mkPlatform old.hostPlatform;
                  targetPlatform = mkPlatform old.targetPlatform;

                  allowedRequisites = null;
                  cc = mkCC newSDK.Libsystem old.cc;
                });
              };
            }
          ]
        ))
        # `builtins.unsafeDiscardStringContext` is used to create a mapping from
        # a store path to a replacement derivation. This is safe because these paths
        # won’t be persisted, and the replacements retain their context.
        #
        # Without being able map from a path to a derivation, every lookup would have
        # to be a linear scan keying off the source derivation. While effectively still
        # O(1) with a big constant (because the number of SDK packages mapped is fixed),
        # the resulting evaluation performance is generally worse overall.
        (lib.concatMap (
          pair:
          map (output: {
            name = lib.pipe pair.original [
              (lib.getOutput output)
              (lib.getAttr "outPath")
              builtins.unsafeDiscardStringContext
            ];
            value = lib.getOutput output pair.replacement;
          }) pair.original.outputs
        ))
        lib.listToAttrs
      ];

      getReplacement =
        pkg:
        let
          replacedPkg =
            if pkg.libc or null != null then
              mkCC (getReplacement pkg.libc) pkg
            else
              replacePropagatedFrameworks pkg;
        in
        if lib.isDerivation pkg then
          newSdkPackages.${builtins.unsafeDiscardStringContext pkg.outPath} or replacedPkg
        else
          pkg;

      replacePropagatedFrameworks =
        pkg:
        let
          propagatedInputs = {
            inherit (pkg)
              depsBuildBuildPropagated
              propagatedNativeBuildInputs
              depsBuildTargetPropagated
              depsHostHostPropagated
              propagatedBuildInputs
              depsTargetTargetPropagated
              ;
          };

          mappedInputs = lib.mapAttrs (name: map getReplacement) propagatedInputs;

          flattenAttrs = lib.flip lib.pipe [
            lib.attrValues
            lib.flatten
          ];

          env = {
            inherit (pkg) outputs;

            # Old dependencies are replaced with new ones via a sed script. It is assumed
            # that `|` will not appear in a store path.
            dependencies = lib.flip lib.pipe [
              (map (pair: "s|${pair.fst}|${pair.snd}|g;"))
              lib.unique
              lib.concatStrings
            ] (lib.zipLists (flattenAttrs propagatedInputs) (flattenAttrs mappedInputs));

            passAsFile = [ "dependencies" ];
          };
        in
        # Only remap the package’s propagated inputs if there are any and if any of them
        # had packages remapped (with frameworks or proxy packages).
        if
          lib.any (inputs: lib.length inputs > 0) (lib.attrValues propagatedInputs)
          && propagatedInputs != mappedInputs
        then
          pkgsHostTarget.runCommand pkg.name env (
            # Map over the outputs in the package being replace to make sure the proxy is
            # a fully functional replacement. This is like `symlinkJoin` except for
            # outputs and the contents of `nix-support`, which will be customized.
            lib.concatMapStringsSep "\n" (output: ''
              outputName='${output}'
              pkgOutputPath='${lib.getOutput output pkg}'

              mkdir -p "''${!outputName}"
              for targetPath in "$pkgOutputPath"/*; do
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
            '') pkg.outputs
          )
        else
          pkg;

      mapInputsToSDK =
        inputs: args: lib.genAttrs inputs (input: map getReplacement (args."${input}" or [ ]));

      mkCC =
        Libsystem: cc:
        cc.override {
          bintools = cc.bintools.override { libc = Libsystem; };
          libc = Libsystem;
        };

      mkPlatform =
        platform:
        platform // lib.optionalAttrs platform.isDarwin { inherit darwinMinVersion darwinSdkVersion; };
    in
    stdenv.override (old: {
      buildPlatform = mkPlatform old.buildPlatform;
      hostPlatform = mkPlatform old.hostPlatform;
      targetPlatform = mkPlatform old.targetPlatform;

      allowedRequisites = null;
      cc = getReplacement old.cc;

      extraBuildInputs = map getReplacement stdenv.extraBuildInputs;
      extraNativeBuildInputs = map getReplacement stdenv.extraNativeBuildInputs;

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
    });
in
overrideSDK
