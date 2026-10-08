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
              cc =
                (old.cc.override (args: {
                  monorepoSrc = args.monorepoSrc.overrideAttrs (_: {
                    name = "selected-clang-source";
                  });
                  buildLlvmPackages = args.buildLlvmPackages // {
                    tblgen = args.buildLlvmPackages.tblgen.overrideAttrs (_: {
                      name = "selected-build-tblgen";
                    });
                  };
                })).overrideAttrs
                  (attrs: {
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
    && compiler.cc.src.outPath == targetCompiler.cc.src.outPath
    && lib.any (lib.hasInfix "selected-build-tblgen") targetCompiler.cc.cmakeFlags
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
            else if policy == "local-ng" then
              {
                cc = packages."gccNGPackages_${toString major}".gcc.cc.override (args: {
                  langFortran = true;
                  monorepoSrc = args.monorepoSrc.overrideAttrs (_: {
                    name = "selected-gcc-source";
                  });
                  buildGccPackages = args.buildGccPackages // {
                    libiberty = args.buildGccPackages.libiberty.overrideAttrs (_: {
                      name = "selected-build-libiberty";
                    });
                  };
                });
              }
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
  localNG =
    (gnuPackages true {
      major = 15;
      ng = true;
      policy = "local-ng";
    }).targetPackages.stdenv.cc;
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
  selectedLinkerPackages = nixpkgsFun {
    localSystem = "x86_64-linux";
    crossSystem = "aarch64-linux";
    config.replaceCrossStdenv =
      { buildPackages, baseStdenv }:
      buildPackages.overrideCC baseStdenv (
        buildPackages.gcc14.override {
          runtimeShell = "/bin/selected-shell";
          nixSupport.__spliced = "ordinary-option-data";
          bintools = buildPackages.llvmPackages_19.bintools.override {
            runtimeShell = "/bin/selected-linker-shell";
            extraBuildCommands = "echo selected-linker > $out/nix-support/selected-linker";
          };
        }
      );
  };
  selectedLinkerCompiler = selectedLinkerPackages.targetPackages.stdenv.cc;
  preservesResourceCompanion =
    toolchain:
    let
      packages = nixpkgsFun {
        localSystem = "x86_64-linux";
        crossSystem = {
          system = "aarch64-linux";
          ${toolchain} = true;
        };
      };
    in
    packages.targetPackages.stdenv.cc.drvPath == packages.gcc.drvPath
    && packages.gccForLibs.drvPath == packages.gcc.cc.drvPath
    && builtins.isString packages.stdenv.cc.drvPath
    && builtins.isString packages.hello.drvPath
    && builtins.isString packages.llvmPackages.libllvm.drvPath;
  # Raw/custom stages can reach postStage without forcing adjacency assertions.
  # Reject unsupported compiler contexts before reinterpreting dependency roles.
  postCompiler =
    stdenv:
    let
      stages =
        import ../../stdenv/booter.nix
          {
            inherit lib;
            allPackages = throw "raw compiler context control must not call allPackages";
          }
          [
            (_: {
              __raw = true;
              inherit stdenv;
            })
          ];
    in
    (builtins.head stages).stdenv.__hatPackages.stdenv.cc;
  projectsContext =
    finalTarget: compilerTarget:
    let
      platform = lib.systems.elaborate;
      compiler = postCompiler {
        buildPlatform = platform "x86_64-linux";
        hostPlatform = platform "aarch64-linux";
        targetPlatform = platform finalTarget;
        hasCC = true;
        cc = {
          isGNU = true;
          stdenv = {
            buildPlatform = platform "x86_64-linux";
            hostPlatform = platform "x86_64-linux";
            targetPlatform = platform compilerTarget;
          };
          override = _: { recalled = true; };
        };
      };
    in
    (builtins.tryEval compiler.recalled).success;

in
assert lib.all preservesResourceCompanion [
  "useZig"
  "useArocc"
];
assert
  postCompiler {
    hasCC = false;
    cc = "no compiler";
  } == "no compiler";
assert
  (postCompiler {
    hasCC = true;
    hostPlatform = lib.systems.elaborate "aarch64-linux";
    cc = {
      stdenv.hostPlatform = lib.systems.elaborate "aarch64-linux";
      unchanged = true;
      isGNU = throw "same-HOST compiler must not be inspected or recalled";
    };
  }).unchanged;
assert projectsContext "aarch64-linux" "aarch64-linux";
assert !projectsContext "riscv64-linux" "riscv64-linux";
assert !projectsContext "aarch64-linux" "riscv64-linux";
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
assert selectedLinkerCompiler.nixSupport.__spliced == "ordinary-option-data";
assert selectedLinkerCompiler.bintools.isLLVM;
assert
  selectedLinkerCompiler.bintools.bintools.version
  == selectedLinkerPackages.stdenv.cc.bintools.bintools.version;
assert lib.hasInfix "selected-linker" selectedLinkerCompiler.bintools.postFixup;
assert selectedLinkerCompiler.shell == "/bin/selected-shell";
assert selectedLinkerCompiler.bintools.shell == "/bin/selected-linker-shell";
assert builtins.isString selectedLinkerCompiler.drvPath;
assert localNG.cc.langFortran;
assert localNG.cc.src.name == "selected-gcc-source";
assert lib.hasInfix "selected-build-libiberty" localNG.cc.preConfigure;
assert builtins.isString localNG.drvPath;
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
