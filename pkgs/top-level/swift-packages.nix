let
  autoCalledPackages = import ./by-name-overlay.nix ../development/compilers/swift/by-name;

  swift_release =
    let
      raw_release = builtins.readFile ../development/compilers/swift/swift-version;
      len = builtins.stringLength raw_release;
    in
    builtins.substring 0 (len - 1) raw_release; # Drop the trailing newline.

  swift_sources_6_2 = builtins.fromJSON (
    # Contains only the hashes for the packages used to build the bootstrap compiler.
    # Hashes for other packages (like SwiftPM) are omitted.
    builtins.readFile ../development/compilers/swift/sources-6.2.json
  );

  swift_sources = builtins.fromJSON (builtins.readFile ../development/compilers/swift/sources.json);

  mkBootstrapSwiftPackages =
    {
      lib,
      bootstrapStage,
      buildSwiftPackages,
      swiftPackages,
      swift_release ? null,
      swift_sources ? null,
    }:
    swiftPackages.overrideScope (
      final: prev:
      {
        inherit bootstrapStage buildSwiftPackages;
        swift = prev.swift.override (
          {
            swift-corelibs-libdispatch = null;
            swift-foundation = null;
            swift-testing = null;
            enableRepl = false;
            enableSourceKitLSP = false;
          }
          # Swift Driver is required when building the compiler’s Swift Syntax in the final toolchain.
          # Otherwise, symbols are stripped from it that are needed to build Swift Testing.
          // lib.optionalAttrs (bootstrapStage == 0) {
            swift-driver = null;
          }
        );
      }
      // lib.optionalAttrs (bootstrapStage != 2) {
        stdlib = null; # Have the bootstrap compiler use its own build of the stdlib.
        swift-driver = prev.swift-driver.overrideAttrs (old: {
          pname = "early-${old.pname}";
        });
      }
      // lib.optionalAttrs (swift_release != null) { inherit swift_release; }
      // lib.optionalAttrs (swift_sources != null) { inherit swift_sources; }
    );
in

{
  lib,
  config,
  clangStdenv,
  generateSplicesForMkScope,
  llvmPackages,
  makeScopeWithSplicing',
  makeSetupHook,
  nix,
  stdenvNoCC,
  swiftPackages,
  writeShellScript,
  otherSplices ? generateSplicesForMkScope "swiftPackages",
}:

let
  # Swift requires three bootstrap stages:
  # - Stage 0 builds a minimal Swift compiler using only C++.
  # - Stage 1 builds a Swift compiler using the stage 0 Swift compiler. Features needed to build macros are enabled.
  # - Stage 2 builds a full Swift compiler and stdlib using the stage 1 compiler.
  bootstrapStage0SwiftPackages62 = mkBootstrapSwiftPackages {
    inherit lib swiftPackages;
    bootstrapStage = 0;
    buildSwiftPackages = swiftPackages.overrideScope (_: _: { swift = null; });
    swift_sources = swift_sources_6_2;
    swift_release = "6.2.4";
  };

  bootstrapStage1SwiftPackages62 = mkBootstrapSwiftPackages {
    inherit lib swiftPackages;
    bootstrapStage = 1;
    buildSwiftPackages = bootstrapStage0SwiftPackages62;
    swift_sources = swift_sources_6_2;
    swift_release = "6.2.4";
  };

  bootstrapStage2SwiftPackages62 = mkBootstrapSwiftPackages {
    inherit lib swiftPackages;
    bootstrapStage = 2;
    buildSwiftPackages = bootstrapStage1SwiftPackages62;
    swift_sources = swift_sources_6_2;
    swift_release = "6.2.4";
  };

  bootstrapStage1SwiftPackages = mkBootstrapSwiftPackages {
    inherit lib swiftPackages;
    bootstrapStage = 1;
    buildSwiftPackages = bootstrapStage2SwiftPackages62;
  };
in

makeScopeWithSplicing' {
  inherit otherSplices;
  extra =
    self:
    let
      llvm_libtool = stdenvNoCC.mkDerivation {
        pname = "libtool";
        version = lib.getVersion llvmPackages.llvm;

        buildCommand = ''
          mkdir -p "$out/bin"
          ln -s ${lib.getExe' llvmPackages.llvm "llvm-libtool-darwin"} "$out/bin/libtool"
        '';
      };

      llvm_readtapi = stdenvNoCC.mkDerivation {
        pname = "llvm-readtapi";
        version = lib.getVersion llvmPackages.llvm;

        buildCommand = ''
          mkdir -p "$out/bin"
          ln -s ${lib.getExe' llvmPackages.llvm "llvm-readtapi"} "$out/bin/llvm-readtapi"
        '';
      };

      createToolchainStubsHook =
        makeSetupHook
          {
            name = "create-toolchain-stubs-hook";
            substitutions = {
              swiftPlatform = stdenvNoCC.hostPlatform.swift.platform;
            };
          }
          (
            # The Swift toolchain expects shared libraries to be found in `lib/swift/<platform>`, but we want them in
            # just `lib`. Trying to patch them out is difficult, so we create text-based stubs on Darwin and symlink
            # the libraries into the expected place on ELF platforms.
            writeShellScript "create-toolchain-stubs-hook" ''
              function createToolchainStubsHook() {
                local dylib
                for dylib in "''${!outputLib}/lib"/*; do
                  if isMachO "$dylib"; then
                    echo "generating text-based stubs for $dylib"
                    ${lib.getExe' llvm_readtapi "llvm-readtapi"} --filetype=tbd-v4 \
                      "$dylib" -o "''${!outputDev}/lib/swift/@swiftPlatform@/$(basename "$dylib" .dylib).tbd"
                  elif isELF "$dylib"; then
                    echo "symlinking $dylib into the standard location"
                    ln -s "$dylib" "''${!outputDev}/lib/swift/@swiftPlatform@/$(basename "$dylib")"
                  fi
                done
              }

              postInstallHooks+=(createToolchainStubsHook)
            ''
          );

      fixUnhelpfulCmakeRpathsHook = makeSetupHook { name = "fix-unhelpful-cmake-rpaths-hook"; } (
        # Swift disables environmental rpaths and tries to set `$ORIGIN`. The latter is probably fine, but the former
        # messes with the tooling in Nixpkgs. This hook removes both of them just to be safe.
        writeShellScript "fix-unhelpful-cmake-rpaths-hook" ''
          function fixUnhelpfulCmakeRpaths() {
            local f
            while IFS= read -d "" f; do
              if [[ "$(basename "$f")" = CMakeLists.txt || "''${f##*.}" = cmake ]]; then
                echo "removing unhelpful rpath settings from '$f'"
                # CMake allows non-zero numbers (including floating point numbers) to be truthy values, but assume that
                # Swift isn’t doing something odd like using 3.141592653589793 as a truth value.
                sed -E -i "$f" \
                  -e 's/(^|\s|CMAKE_)INSTALL_RPATH "[^"]*"/\1INSTALL_RPATH ""/' \
                  -e 's/(^|\s|CMAKE_)INSTALL_REMOVE_ENVIRONMENT_RPATH (1|ON|TRUE|Y|YES)/\1INSTALL_REMOVE_ENVIRONMENT_RPATH OFF/'
              fi
            done < <(grep -rlZ RPATH)
          }
          postPatchHooks+=(fixUnhelpfulCmakeRpaths)
        ''
      );

      /**
        Provides a list of patches for the specified major.minor version.

        # Inputs
        `path`
        : The path where to get patches (excluding version-based path components).
          The function at `<path>/<version.major>.<version.minor>/default.nix` is called with `callPackage`.

        `version`
        : The package’s version for which to get patches (typically `finalAttrs.version`)

        `...`
        : Additional arguments passed to `callPackage`.

        # Type
        ```
        patchesForVersion :: { path :: Path, version :: String, ... } -> [Derivation | Path]

        # Examples
        :::{.example}
        ## `patchesForVersion` usage example

        ```nix
        patches = patchesForVersion {
          version = "6.2.4";
          path = ./patches;
        }
        => [
        [
          <path>/patches/6.2/0001-Read-C-and-C-stdlib-flags-from-the-wrapped-compiler.patch
          <path>/patches/6.2/0002-Use-Nixpkgs-C-and-C-stdlib-paths-in-ClangImporter.patch
          <path>/patches/6.2/0003-cmark-build-revamp.patch
          <path>/patches/6.2/0004-sil-missing-headers.patch
          «derivation /nix/store/nwpjbbdszqzk0idizcm5rza1w4iql0m1-0005-specify-liblto-path.patch.drv»
          <path>/patches/6.2/0006-use-nixpkgs-libdispatch.patch
          «derivation /nix/store/bxj26lblfhjz77aliyjgz6alpcxazs2l-0007-Help-Swift-JIT-find-the-separate-stdlib-and-framewor.patch.drv»
          «derivation /nix/store/x3nk6n2ar2j31xb40cijg7dalwrcm2sn-cfbe70db5d1e65bed2388f97ee52f65719c812b3.patch?full_index=1.drv»
        ]
        ```

        :::
      */
      patchesForVersion =
        { path, version, ... }@args:
        let
          args' = lib.removeAttrs args [
            "path"
            "version"
          ];
        in
        self.callPackage (lib.path.append path (lib.versions.majorMinor version)) args';
    in
    {
      bootstrapStage = 2;

      buildSwiftPackages = bootstrapStage1SwiftPackages;

      inherit
        llvm_libtool
        patchesForVersion
        swift_sources
        # Hooks to make it easier to deal with Swift packaging
        createToolchainStubsHook
        fixUnhelpfulCmakeRpathsHook
        ;

      llvmPackages_upstream = llvmPackages;

      swift-minimal = self.swift.override {
        swift-corelibs-libdispatch = null;
        swift-driver = null;
        swift-foundation = null;
        swift-testing = null;
        enableRepl = false;
        enableSourceKitLSP = false;
      };
    };
  f = lib.extends autoCalledPackages (
    self:
    let
      # Can’t be defined in `by-name` because it’s a function.
      swiftpmDepsUpdater =
        let
          updateScript = writeShellScript "swiftpm-deps-updater.sh" ''
            set -o errexit

            resolve_swift_package=$1
            source_root=$2

            [[ -n "$version" ]] || version="$UPDATE_NIX_OLD_VERSION"
            [[ -n "$attr_path" ]] || attr_path="$UPDATE_NIX_ATTR_PATH"

            # The SwiftPM deps updater assumes some other updater has run and updated the version attribute.
            new_version=$(
              ${lib.getExe' nix "nix-instantiate"} --eval --raw --expr "with import ./. {}; lib.getVersion $attr_path"
            )

            if [ "$version" = "$new_version" ]; then
              exit 0
            fi

            export PATH=${lib.getBin self.swift}/bin:${lib.getBin self.swiftpm}/bin:$PATH

            src=$(${lib.getExe' nix "nix-instantiate"} --eval --raw -A $attr_path.src)
            package_file=$(${lib.getExe' nix "nix-instantiate"} --eval --raw -A $attr_path.meta.position | cut -d: -f1)

            if [ -n "$resolve_swift_package" ]; then
              resolved_file=$(dirname "$package_file")/Package.resolved

              scratch_dir=$(mktemp -d)
              trap 'rm -rf -- "$scratch_dir"' EXIT

              cp -r "$src/" "$scratch_dir/source/"
              chmod -R u+w "$scratch_dir/source"

              pushd "$scratch_dir/$source_root" > /dev/null
              swift package resolve &> /dev/null
              cp Package.resolved "$resolved_file"
              popd > /dev/null
              echo "done resolving" >&2
            else
              resolved_file=$src/Package.resolved
            fi

            deps_hash=$(${lib.getExe self.prefetch-swiftpm-deps} "$resolved_file")
            sed -e "s|$(${lib.getExe' nix "nix-instantiate"} --eval --raw -A $attr_path.swiftpmDeps.vendorStaging.outputHash)|$deps_hash|" --in-place "$package_file"
          '';
        in
        {
          sourceRoot ? "source",
          # Some packages do not provide `Package.resolved`. If true, one will be generated and saved next to the package.
          resolveSwiftPackage ? false,
        }:
        {
          name = "swiftpm-deps-updater";
          command = [
            updateScript
            resolveSwiftPackage
            sourceRoot
          ];
          supportedFeatures = [ "silent" ];
        };
    in
    {
      stdenv = clangStdenv;
      inherit swiftpmDepsUpdater swift_release;
    }
    // lib.optionalAttrs config.allowAliases {
      # Compatibility aliases for the old Swift packaging.
      swift-unwrapped = lib.warnOnInstantiate "Swift is no longer wrapped. Use `swift` directly." self.swift;
      swiftNoSwiftDriver =
        lib.warnOnInstantiate
          "swiftNoSwiftDriver is an alias. Override `swift` and set `swift-driver` to `null` instead."
          (self.swift.override { swift-driver = null; });
      Dispatch = lib.warnOnInstantiate "Dispatch has been renamed to swift-corelibs-libdispatch. It is also now included in the default Swift SDK and no longer needs referenced as a separate package." self.swift-corelibs-libdispatch;
      Foundation = lib.warnOnInstantiate "Foundation has been renamed to swift-corelibs-foundation. It is also now included in the default Swift SDK and no longer needs referenced as a separate package." self.swift-corelibs-foundation;
      XCTest = lib.warnOnInstantiate "XCTest has been renamed to swift-corelibs-xctest. It is also now included in the default Swift SDK and no longer needs referenced as a separate package." self.swift-corelibs-xctest;
    }
  );
}
