# Cross-compilation stdenv sets
{
  lib,
  stdenv,
  config,
  overlays,
  cxxlibCrossChooser,
  rtlibCrossChooser,
  unwinderlibCrossChooser,
  bintoolsChooser,
  ccCrossChooser,
  libcCrossChooser,
  wrapBintoolsWith,
}:
let
  inherit (lib) genAttrs optionalAttrs optionalString;

  # TODO: use cxxlib when https://github.com/NixOS/nixpkgs/pull/365057 is merged
  cxxlibNameFor =
    targetPlatform:
    if
      targetPlatform.useLLVM
      || (targetPlatform.useArocc or false)
      || (targetPlatform.useZig or false)
      || targetPlatform.isDarwin
    then
      "libcxx"
    else
      "libstdcxx";

  # TODO: use rtlib when https://github.com/NixOS/nixpkgs/pull/365057 is merged
  rtlibNameFor =
    targetPlatform:
    if
      targetPlatform.useLLVM
      || (targetPlatform.useArocc or false)
      || (targetPlatform.useZig or false)
      || (targetPlatform.isDarwin)
    then
      "compiler-rt"
    else
      "libgcc";

  # TODO: use unwinderlib when https://github.com/NixOS/nixpkgs/pull/365057 is merged
  unwinderlibNameFor =
    targetPlatform:
    if
      targetPlatform.useLLVM || (targetPlatform.useArocc or false) || (targetPlatform.useZig or false)
    then
      "libunwind"
    else if targetPlatform.isDarwin then
      "libunwind-system"
    else
      "libgcc_s";

  overrideCxxlibWith =
    targetPlatform:
    {
      libc ? null,
      rtlib ? null,
      unwinderlib ? null,
    }@args:
    let
      name = cxxlibNameFor targetPlatform;
      cxxlib = cxxlibCrossChooser name;
    in
    if cxxlib != null then
      cxxlib.override ({
        stdenv = stdenv.override {
          hostPlatform = targetPlatform;
          inherit targetPlatform;
          cc = overrideCCWith targetPlatform args;
          allowedRequisites = null;
        };
      })
    else
      null;

  overrideCxxlib =
    targetPlatform:
    overrideCxxlibWith targetPlatform (rec {
      libc = overrideLibcWith targetPlatform { };
      rtlib = overrideRtlibWith targetPlatform { };
    });

  overrideRtlibWith =
    targetPlatform:
    {
      libc ? null,
      rtlib ? null,
      cxxlib ? null,
      unwinderlib ? null,
    }@args:
    let
      name = rtlibNameFor targetPlatform;
      cxxlibName = cxxlibNameFor targetPlatform;
      rtlib = rtlibCrossChooser name;
    in
    if rtlib != null then
      rtlib.override (
        {
          stdenv = stdenv.override {
            hostPlatform = targetPlatform;
            inherit targetPlatform;
            cc = overrideCCWith targetPlatform args;
            allowedRequisites = null;
          };
        }
        // optionalAttrs (name == "compiler-rt") {
          libcxx = if cxxlibName == "libcxx" then cxxlib else null;
        }
      )
    else
      null;

  overrideRtlib =
    targetPlatform:
    overrideRtlibWith targetPlatform (rec {
      libc = overrideLibcWith targetPlatform { };
      rtlib = overrideRtlibWith targetPlatform { };
      unwinderlib = overrideUnwinderlibWith targetPlatform {
        inherit rtlib libc;
      };
      cxxlib = overrideCxxlibWith targetPlatform {
        inherit rtlib libc unwinderlib;
      };
    });

  overrideUnwinderlibWith =
    targetPlatform:
    {
      libc ? null,
      rtlib ? null,
    }@args:
    let
      unwinderlib = unwinderlibCrossChooser (unwinderlibNameFor targetPlatform);
    in
    if unwinderlib != null && !targetPlatform.isWasm then
      unwinderlib.override {
        stdenv = stdenv.override {
          hostPlatform = targetPlatform;
          inherit targetPlatform;
          cc = overrideCCWith targetPlatform args;
          allowedRequisites = null;
        };
      }
    else
      null;

  overrideUnwinderlib =
    targetPlatform:
    overrideUnwinderlibWith targetPlatform {
      libc = overrideLibcWith targetPlatform { };
      rtlib = overrideRtlibWith targetPlatform { };
    };

  overrideBintoolsWithLibc =
    targetPlatform: libc:
    let
      bintools = bintoolsChooser targetPlatform.linker;
    in
    if bintools != null then
      wrapBintoolsWith {
        stdenvNoCC = stdenv.override {
          inherit targetPlatform;
          cc = null;
          hasCC = false;
        };
        bintools = bintools.override (
          {
            stdenv = stdenv.override {
              inherit targetPlatform;
              allowedRequisites = null;
            };
          }
          // optionalAttrs (bintools.isGNU or false) {
            buildPackages = {
              inherit stdenv;
            };
          }
        );
        inherit libc;
        noLibc = libc == null;
      }
    else
      null;

  overrideBintools =
    targetPlatform: overrideBintoolsWithLibc targetPlatform (overrideLibc targetPlatform);

  overrideLibcWith =
    targetPlatform:
    {
      unwinderlib ? null,
      rtlib ? null,
    }@args:
    let
      libc = libcCrossChooser targetPlatform.libc;

      gccWithoutTargetLibc =
        let
          cc = ccCrossChooser "gcc";
        in
        cc.override {
          stdenvNoCC = cc.stdenv.override {
            inherit targetPlatform;
            allowedRequisites = null;
          };
          bintools = overrideBintoolsWithLibc targetPlatform null;
          cc = cc.cc.override {
            libcCross = null;
          };
          libc = null;
          noLibc = true;
        };

      gccCrossLibcStdenv = stdenv.override {
        inherit targetPlatform;
        cc = gccWithoutTargetLibc;
        hasCC = true;
        allowedRequisites = null;
      };
    in
    if libc != null then
      libc.override (
        {
          stdenv = libc.stdenv.override {
            hostPlatform = targetPlatform;
            inherit targetPlatform;
            cc =
              if targetPlatform.libc == "glibc" then gccWithoutTargetLibc else overrideCCWith targetPlatform args;
            hasCC = true;
            allowedRequisites = null;
          };
        }
        // optionalAttrs (targetPlatform.libc == "glibc") {
          libgcc = libc.libgcc.override {
            gcc = gccWithoutTargetLibc;
            glibc = libc.override {
              stdenv = libc.stdenv.override {
                inherit targetPlatform;
                cc = gccWithoutTargetLibc;
                hasCC = true;
                allowedRequisites = null;
              };
              libgcc = null;
            };
            stdenvNoLibs = gccCrossLibcStdenv;
          };
        }
      )
    else
      null;

  overrideLibc =
    targetPlatform:
    overrideLibcWith targetPlatform {
      unwinderlib = overrideUnwinderlibWith targetPlatform { };
      rtlib = overrideRtlibWith targetPlatform { };
    };

  overrideCCWith =
    targetPlatform:
    {
      libc ? null,
      unwinderlib ? null,
      rtlib ? null,
      cxxlib ? null,
    }:
    let
      cc = ccCrossChooser (
        if targetPlatform.useLLVM or targetPlatform.isDarwin then
          "clang"
        else if targetPlatform.useArocc or false then
          "arocc"
        else if targetPlatform.useZig or false then
          "zig"
        else
          "gcc"
      );

      cc' = cc.cc.override (
        {
          stdenv = stdenv.override {
            inherit targetPlatform;
            allowedRequisites = null;
            cc = stdenv.cc.override {
              stdenvNoCC = stdenv.cc.stdenv.override {
                cc = null;
              };
              cc = stdenv.cc.cc.override (
                optionalAttrs (stdenv.cc.cc.isGNU or false) {
                  libcCross = null;
                }
              );
            };
          };
        }
        // optionalAttrs (cc.cc.isGNU or false) {
          libcCross = libc;
          withoutTargetLibc = libc == null;
          langCC = libc != null;
          buildPackages = {
            inherit stdenv;
          };
          targetPackages = {
            stdenv = stdenv.override {
              inherit targetPlatform;
              cc = stdenv.cc.override {
                stdenvNoCC = stdenv.override {
                  inherit targetPlatform;
                  cc = null;
                  hasCC = false;
                };
                cc = stdenv.cc.cc.override (
                  {
                    inherit stdenv;
                  }
                  // optionalAttrs (stdenv.cc.cc.isGNU or false) {
                    libcCross = null;
                  }
                );
                libc = null;
                noLibc = true;
                bintools = overrideBintoolsWithLibc targetPlatform null;
              };
            };
          };
        }
      );
    in
    if cc != null then
      cc.override (
        {
          stdenvNoCC = cc.stdenv.override {
            inherit targetPlatform;
            allowedRequisites = null;
          };
          bintools = overrideBintoolsWithLibc targetPlatform libc;
          cc = cc';
          inherit libc;
          noLibc = libc == null;
          libcxx = cxxlib;
        }
        // optionalAttrs (cc'.isClang or false) {
          # TODO: put this stuff into the CC wrapper
          extraPackages =
            lib.optional (rtlib != null) rtlib
            ++ lib.optional (
              unwinderlib != null && !targetPlatform.isWasm && !targetPlatform.isFreeBSD
            ) unwinderlib;
          extraBuildCommands =
            ''
              rsrc="$out/resource-root"
              mkdir "$rsrc"
              ln -s "${lib.getLib cc'}/lib/clang/${lib.versions.major cc'.version}/include" "$rsrc"
              echo "-resource-dir=$rsrc" >> $out/nix-support/cc-cflags
            ''
            + optionalString (rtlib != null) ''
              if [[ -e "${rtlib.out}/lib" ]]; then
                ln -s "${rtlib.out}/lib" "$rsrc/lib"
              fi

              if [[ -e "${rtlib.out}/share" ]]; then
                ln -s "${rtlib.out}/share" "$rsrc/share"
              fi
            '';
          nixSupport.cc-cflags =
            # TODO: add a mechanism to get the rtlib's name
            lib.optional (!targetPlatform.isWasm) "-rtlib=${rtlibNameFor targetPlatform}"
            # libunwind-system is returned on Darwin
            # TODO: add a mechanism to get the unwinderlib's name
            ++ lib.optionals (unwinderlib != null) [
              "-unwindlib=${if targetPlatform.isDarwin then "libunwind" else unwinderlibNameFor targetPlatform}"
              "-L${unwinderlib}/lib"
              "-Wno-unused-command-line-argument"
            ]
            ++ lib.optional (cxxlib == null) "-nostdlib++"
            ++ lib.optional (rtlib != null) "-B${rtlib}/lib"
            ++ lib.optional (
              !targetPlatform.isWasm && !targetPlatform.isFreeBSD && targetPlatform.useLLVM && unwinderlib != null
            ) "-lunwind"
            ++ lib.optional (targetPlatform.isWasm) "-fno-exceptions";
        }
      )
    else
      null;

  overrideCC =
    targetPlatform:
    overrideCCWith targetPlatform {
      libc = overrideLibc targetPlatform;
      rtlib =
        if targetPlatform.isWasm then
          overrideRtlibWith targetPlatform { }
        else
          overrideRtlib targetPlatform;
      unwinderlib = overrideUnwinderlib targetPlatform;
      cxxlib = overrideCxxlib targetPlatform;
    };

  overrideStdenv =
    system:
    let
      targetPlatform = lib.systems.elaborate system;
    in
    stdenv.override {
      hostPlatform = targetPlatform;
      inherit targetPlatform;
      cc = overrideCC targetPlatform;
      allowedRequisites = null;
    };

  predicates = [
    "useLLVM"
    "isStatic"
  ];

  libcs = [
    "musl"
    "glibc"
    "newlib"
  ];

  configs = [
    "aarch64-unknown-linux-gnu"
    "aarch64-unknown-linux-musl"
    "arm-none-eabi"
    "wasm32-unknown-wasi"
  ];

  mkConfigSet =
    platform:
    genAttrs configs (
      config:
      overrideStdenv (
        platform
        // {
          inherit config;
        }
      )
    );

  mkPredicatedSet =
    platform:
    genAttrs predicates (
      predicate:
      mkSet (
        platform
        // {
          "${predicate}" = true;
        }
      )
    );

  mkLibcSet =
    platform:
    genAttrs libcs (
      libc:
      mkSet (
        platform
        // {
          inherit libc;
        }
      )
    );

  mkSet = platform: {
    configs = mkConfigSet platform;
    predicated = mkPredicatedSet platform;
    libc = mkLibcSet platform;
    recurseForDerivations = false;
  };
in
mkSet { }
