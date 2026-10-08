{
  lib,
  pkgs,
  nixpkgsFun,
}:
let
  withRuntime =
    runtime: major:
    nixpkgsFun {
      localSystem = "x86_64-linux";
      crossSystem = {
        system = "aarch64-linux";
        useLLVM = true;
        linker = "lld";
      };
      config.replaceCrossStdenv =
        { buildPackages, baseStdenv }:
        let
          llvm = buildPackages."llvmPackages_${toString major}";
          frontend = llvm.clangUseLLVM.override (
            old:
            let
              cc = old.cc.overrideAttrs (attrs: {
                postInstall = (attrs.postInstall or "") + "\n: selected-clang-frontend\n";
              });
            in
            {
              inherit cc;
              extraBuildCommands =
                builtins.replaceStrings [ (toString (lib.getLib old.cc)) ] [ (toString (lib.getLib cc)) ]
                  old.extraBuildCommands;
            }
          );
        in
        buildPackages.overrideCC baseStdenv (
          if runtime == "libstdcxx" then
            frontend.override {
              libcxx = buildPackages.targetPackages.gccNGPackages.libstdcxx;
              # Preserve the implicit GNU provider policy too. These fields
              # remain meaningful metadata even when useLLVM selects libcxx.
              gccForLibs = buildPackages.gcc14.cc;
              useCcForLibs = false;
            }
          else
            frontend
        );
    };
  preservesRuntime =
    runtime: major:
    let
      packages = withRuntime runtime major;
      compiler = packages.stdenv.cc;
      targetCompiler = packages.targetPackages.stdenv.cc;
    in
    compiler.isClang
    && targetCompiler.isClang
    && compiler.version == targetCompiler.version
    && lib.hasInfix ": selected-clang-frontend" targetCompiler.cc.postInstall
    && lib.hasInfix (builtins.unsafeDiscardStringContext "${lib.getLib compiler.cc}/lib/clang/${toString major}/include") targetCompiler.postFixup
    && compiler.bintools.bintools.version == targetCompiler.bintools.bintools.version
    && compiler.libcxx.outPath == targetCompiler.libcxx.outPath
    && compiler.gccForLibs.outPath == targetCompiler.gccForLibs.outPath
    && compiler.useCcForLibs == targetCompiler.useCcForLibs
    && compiler.nixSupport == targetCompiler.nixSupport
    &&
      map toString compiler.depsTargetTargetPropagated
      == map toString targetCompiler.depsTargetTargetPropagated
    && lib.systems.equals targetCompiler.stdenv.hostPlatform packages.stdenv.hostPlatform
    && lib.systems.equals targetCompiler.stdenv.targetPlatform packages.stdenv.targetPlatform
    # Role metadata alone can hide a bootstrap dependency cycle.
    && builtins.isString compiler.drvPath
    && builtins.isString targetCompiler.drvPath;

  gnuPackages =
    cross:
    {
      major ? 14,
      policy ? "implicit",
      ng ? false,
      overlays ? [ ],
    }:
    let
      select =
        packages:
        (if ng then packages."gccNGPackages_${toString major}".gcc else packages."gcc${toString major}")
        .override
          (
            if policy == "explicit" then
              {
                useCcForLibs = true;
                gccForLibs = packages.gcc14.cc;
              }
            else if policy == "null" then
              {
                useCcForLibs = true;
                gccForLibs = null;
              }
            else if policy == "libcxx" then
              # Bootstrap this independent runtime with GCC rather than with the
              # compiler whose runtime is being selected here.
              { libcxx = packages.llvmPackages.libcxx.override { stdenv = packages.gccStdenv; }; }
            else if policy == "local-frontend" then
              {
                cc =
                  (packages.gcc14.cc.override {
                    langFortran = true;
                    reproducibleBuild = false;
                    noSysDirs = false;
                  }).overrideAttrs
                    (old: {
                      postInstall = (old.postInstall or "") + "\n: local-frontend\n";
                    });
              }
            else
              { }
          );
    in
    nixpkgsFun (
      {
        localSystem = "x86_64-linux";
        inherit overlays;
        config = {
          allowUnfree = true;
          cudaCapabilities = [ "8.0" ];
        }
        // (
          if cross then
            {
              replaceCrossStdenv =
                { buildPackages, baseStdenv }: buildPackages.overrideCC baseStdenv (select buildPackages);
            }
          else
            {
              replaceStdenv = { pkgs }: pkgs.overrideCC pkgs.stdenv (select pkgs);
            }
        );
      }
      // lib.optionalAttrs cross {
        crossSystem = {
          system = "aarch64-linux";
        }
        // lib.optionalAttrs ng { useGccNG = true; };
      }
    );
  provider =
    cc:
    if cc.libcxx != null then
      cc.libcxx
    else if cc.useGccForLibs then
      cc.gccForLibs
    else
      cc.cc;
  preservesGNU =
    cross: args:
    let
      packages = gnuPackages cross args;
      source = packages.stdenv.cc;
      host = packages.targetPackages.stdenv.cc;
      cuda = packages.cudaPackages_13_3;
      compilers = [
        host
        cuda.backendCC
        cuda.backendStdenv.cc
      ];
    in
    host.version == source.version
    && lib.all (
      cc: (provider cc).outPath == (provider source).outPath && builtins.isString cc.drvPath
    ) compilers
    && lib.systems.equals host.stdenv.hostPlatform packages.stdenv.hostPlatform
    && lib.systems.equals cuda.backendCC.stdenv.hostPlatform packages.stdenv.hostPlatform
    && lib.systems.equals cuda.backendStdenv.cc.stdenv.hostPlatform packages.stdenv.buildPlatform
    &&
      lib.versions.major cuda.backendCC.version
      == (if args.major or 14 == 16 then "15" else toString (args.major or 14));
  localFrontend = (gnuPackages true { policy = "local-frontend"; }).targetPackages.stdenv.cc;
  withDependency = gnuPackages true {
    overlays = [
      (_: prev: {
        mpfr = prev.mpfr.overrideAttrs (old: {
          postInstall = (old.postInstall or "") + "\n: role-dependency\n";
        });
      })
    ];
  };
in
assert lib.all
  (
    runtime:
    lib.all (preservesRuntime runtime) [
      19
      21
    ]
  )
  [
    "libstdcxx"
    "libcxx"
  ];
assert lib.all
  (
    cross:
    lib.all (preservesGNU cross) [
      { }
      { policy = "explicit"; }
      { policy = "null"; }
      { policy = "libcxx"; }
      {
        major = 16;
        policy = "explicit";
      }
      { major = 16; }
    ]
  )
  [
    false
    true
  ];
assert preservesGNU true {
  major = 15;
  ng = true;
};
assert localFrontend.cc.langFortran;
assert !localFrontend.cc.noSysDirs;
assert lib.hasInfix ": local-frontend" localFrontend.cc.postInstall;
assert builtins.isString localFrontend.drvPath;
assert lib.hasInfix ": role-dependency" withDependency.mpfr.postInstall;
assert builtins.elem withDependency.mpfr.dev.outPath (
  map (dependency: dependency.outPath) withDependency.targetPackages.stdenv.cc.cc.buildInputs
);
assert builtins.isString withDependency.targetPackages.stdenv.cc.drvPath;
pkgs.emptyFile
