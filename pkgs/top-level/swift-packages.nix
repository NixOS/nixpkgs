let
  autoCalledPackages = import ./by-name-overlay.nix ../development/compilers/swift_ng/by-name;

  swift_sources_6_2 = builtins.fromJSON (
    builtins.readFile ../development/compilers/swift_ng/sources-6.2.json
  );

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
  clangStdenv,
  generateSplicesForMkScope,
  llvmPackages,
  makeScopeWithSplicing',
  stdenvNoCC,
  swiftPackages_ng,
  otherSplices ? generateSplicesForMkScope "swiftPackages_ng",
}:

let
  # Swift requires three bootstrap stages:
  # - Stage 0 builds a minimal Swift compiler using only C++.
  # - Stage 1 builds a Swift compiler using the stage 0 Swift compiler. Features needed to build macros are enabled.
  # - Stage 2 builds a full Swift compiler and stdlib using the stage 1 compiler.
  bootstrapStage0SwiftPackages = mkBootstrapSwiftPackages {
    inherit lib;
    swiftPackages = swiftPackages_ng;
    bootstrapStage = 0;
    buildSwiftPackages = swiftPackages_ng.overrideScope (_: _: { swift = null; });
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
    in
    {
      bootstrapStage = 1;

      buildSwiftPackages = bootstrapStage0SwiftPackages;

      inherit llvm_libtool;

      llvmPackages_upstream = llvmPackages;

      swift-minimal = self.swift.override {
        swift-corelibs-libdispatch = null;
        swift-driver = null;
        swift-foundation = null;
      };

      swift_sources = swift_sources_6_2;
    };
  f = lib.extends autoCalledPackages (self: {
    stdenv = clangStdenv;
    swift_release = "6.2.4";
  });
}
