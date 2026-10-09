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
            else if
              builtins.elem policy [
                "compatible-build-cc"
                "incompatible-build-cc"
              ]
            then
              {
                cc = packages.gcc14.cc.override (original: {
                  stdenv = original.stdenv.override {
                    cc =
                      (if policy == "compatible-build-cc" then packages.gcc15 else packages.buildPackages.gcc15).override
                        {
                          extraBuildCommands = "echo selected-build-compiler > $out/nix-support/selected-build-compiler";
                        };
                  };
                });
              }
            else if policy == "local-stdenv" then
              {
                cc = packages.gcc14.cc.override (original: {
                  stdenv = packages.withCFlags [ "-DSELECTED_CONSTRUCTOR=1" ] (
                    original.stdenv.override (old: {
                      name = "selected-compiler-build-context";
                      preHook = (old.preHook or "") + "\nexport SELECTED_CONSTRUCTOR=1\n";
                      extraBuildInputs = (old.extraBuildInputs or [ ]) ++ [ packages.zlib ];
                      extraNativeBuildInputs = (old.extraNativeBuildInputs or [ ]) ++ [ packages.pkg-config ];
                    })
                  );
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
  selectedContexts = map (cross: gnuPackages cross { policy = "local-stdenv"; }) [
    false
    true
  ];
  compatiblePackages = gnuPackages true { policy = "compatible-build-cc"; };
  incompatiblePackages = gnuPackages true { policy = "incompatible-build-cc"; };
  compatibleBuildCC = compatiblePackages.targetPackages.stdenv.cc.cc.stdenv.cc;
  incompatibleBuildCC = incompatiblePackages.targetPackages.stdenv.cc.cc.stdenv.cc;

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
  staticPackages = nixpkgsFun { localSystem = "x86_64-linux"; };
  staticBase = staticPackages.stdenvAdapters.makeStaticBinaries staticPackages.stdenv;
  selectedLibc = staticPackages.glibc.overrideAttrs (_: {
    pname = "selected-static-libc";
  });
  selectStaticLibc =
    libc:
    staticPackages.overrideCC staticBase (
      staticPackages.stdenv.cc.override {
        inherit libc;
        bintools = staticPackages.stdenv.cc.bintools.override { inherit libc; };
      }
    );
  staticSelected = selectStaticLibc selectedLibc;
  missingStaticLibc = staticPackages.glibc.overrideAttrs (old: {
    outputs = lib.remove "static" old.outputs;
  });
  renamedStaticLibc = staticPackages.glibc.overrideAttrs (
    final: old: {
      outputs = map (name: if name == "static" then "archives" else name) old.outputs;
      postInstall = builtins.replaceStrings [ "$static" ] [ "$archives" ] old.postInstall;
      passthru = (old.passthru or { }) // {
        static = final.finalPackage.archives;
      };
    }
  );
  twiceStatic = staticPackages.stdenvAdapters.makeStaticBinaries staticBase;
  staticNoCC = staticBase.override {
    hasCC = false;
    cc = throw "noCC must not inspect compiler";
  };
  staticNullLibc = staticPackages.overrideCC staticBase (
    staticPackages.stdenv.cc.override {
      libc = null;
      noLibc = true;
      nativeLibc = false;
      bintools = staticPackages.stdenv.cc.bintools.override {
        libc = null;
        noLibc = true;
        nativeLibc = false;
      };
    }
  );
  staticExplicit = staticBase.override { extraBuildInputs = [ staticPackages.zlib ]; };
  staticCleared = staticExplicit.override { extraBuildInputs = [ ]; };
  staticCross =
    libc:
    nixpkgsFun {
      localSystem = "x86_64-linux";
      crossSystem = {
        system = "aarch64-linux";
        isStatic = true;
        inherit libc;
      };
    };
  staticGlibc = staticCross "glibc";
  staticMusl = staticCross "musl";
  probeStatic =
    stdenv:
    stdenv.mkDerivation {
      name = "static-default-resource-order";
      buildInputs = [ staticPackages.libxml2 ];
      propagatedBuildInputs = [ staticPackages.zlib ];
      depsTargetTarget = [ staticPackages.gmp ];
      buildCommand = "touch $out";
    };

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
assert
  map (x: x.outPath) staticBase.extraBuildInputs
  == [ (lib.getOutput "static" staticPackages.stdenv.cc.libc).outPath ];
assert
  map (x: x.outPath) staticSelected.extraBuildInputs
  == [ (lib.getOutput "static" selectedLibc).outPath ];
assert
  !(builtins.tryEval (builtins.deepSeq (selectStaticLibc missingStaticLibc).extraBuildInputs true))
  .success;
assert
  map (x: x.outPath) (selectStaticLibc renamedStaticLibc).extraBuildInputs
  == [ renamedStaticLibc.archives.outPath ];
# Adapter application composes ordered contributions; it is not idempotent.
assert
  map (x: x.outPath) twiceStatic.extraBuildInputs
  == map (x: x.outPath) (staticBase.extraBuildInputs ++ staticBase.extraBuildInputs);
assert staticNoCC.extraBuildInputs == [ ] && builtins.isString (probeStatic staticNoCC).drvPath;
assert staticNullLibc.extraBuildInputs == [ ];
assert
  map (x: x.outPath) staticExplicit.extraBuildInputs == [
    staticPackages.zlib.outPath
    (lib.getOutput "static" staticPackages.stdenv.cc.libc).outPath
  ];
assert
  map (x: x.outPath) staticCleared.extraBuildInputs == map (x: x.outPath) staticBase.extraBuildInputs;
assert
  map (x: x.outPath) (probeStatic staticBase).buildInputs == [ staticPackages.libxml2.dev.outPath ];
assert
  map (x: x.outPath) (probeStatic staticBase).propagatedBuildInputs
  == [ staticPackages.zlib.dev.outPath ];
assert lib.all
  (
    stdenv: lib.all (input: input.stdenv.hostPlatform.system == "aarch64-linux") stdenv.extraBuildInputs
  )
  [
    staticGlibc.stdenv
    staticGlibc.targetPackages.stdenv.cc.cc.stdenv
  ];
assert staticGlibc.stdenvNoCC.extraBuildInputs == [ ];
assert
  staticMusl.stdenv.extraBuildInputs == [ ]
  && staticMusl.targetPackages.stdenv.cc.cc.stdenv.extraBuildInputs == [ ];
assert selectedLinkerCompiler.bintools.isLLVM;
assert
  selectedLinkerCompiler.bintools.bintools.version
  == selectedLinkerPackages.stdenv.cc.bintools.bintools.version;
assert lib.hasInfix "selected-linker" selectedLinkerCompiler.bintools.postFixup;
assert selectedLinkerCompiler.shell == "/bin/selected-shell";
assert selectedLinkerCompiler.bintools.shell == "/bin/selected-linker-shell";
assert builtins.isString selectedLinkerCompiler.drvPath;
# These are construction controls. An incompatible native compiler does not
# acquire a different TARGET merely by changing its enclosing stdenv platforms.
assert compatibleBuildCC.outPath == compatiblePackages.stdenv.cc.cc.stdenv.cc.outPath;
assert lib.hasInfix "selected-build-compiler" compatibleBuildCC.postFixup;
assert incompatibleBuildCC.outPath == incompatiblePackages.stdenv.cc.outPath;
assert !(lib.hasInfix "selected-build-compiler" incompatibleBuildCC.postFixup);
assert compatibleBuildCC.stdenv.hostPlatform.system == "x86_64-linux";
assert compatibleBuildCC.stdenv.targetPlatform.system == "aarch64-linux";
assert lib.all (
  packages:
  let
    source = packages.stdenv.cc.cc;
    target = packages.targetPackages.stdenv.cc.cc;
  in
  target.stdenv.name == source.stdenv.name
  && target.env.NIX_CFLAGS_COMPILE == source.env.NIX_CFLAGS_COMPILE
  && lib.hasInfix "SELECTED_CONSTRUCTOR=1" target.stdenv.preHook
  &&
    map (x: x.outPath) target.stdenv.extraBuildInputs
    == map (x: x.outPath) source.stdenv.extraBuildInputs
  && lib.all (
    input: builtins.elem input.outPath (map (x: x.outPath) target.stdenv.extraNativeBuildInputs)
  ) source.stdenv.extraNativeBuildInputs
  && builtins.isString target.drvPath
) selectedContexts;
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
