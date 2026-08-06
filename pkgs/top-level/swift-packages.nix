let
  autoCalledPackages = import ./by-name-overlay.nix ../development/compilers/swift_ng/by-name;

  swift_sources_6_2 = builtins.fromJSON (
    builtins.readFile ../development/compilers/swift_ng/sources-6.2.json
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
      bootstrapStage = 0;

      buildSwiftPackages = swiftPackages_ng.overrideScope (_: _: { swift = null; });

      inherit llvm_libtool;

      llvmPackages_upstream = llvmPackages;

      swift_sources = swift_sources_6_2;
    };
  f = lib.extends autoCalledPackages (self: {
    stdenv = clangStdenv;
    swift_release = "6.2.4";
  });
}
