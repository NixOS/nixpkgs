{
  stdenv,
  coreutils,
  replaceVars,
  majorVersion,
  defaultShell,
  jdk_headless,
  addFilePatch,
}:
let
  commonPatches = [
    (addFilePatch {
      path = "b/third_party/rules_java.patch";
      file = replaceVars ./patches/rules_java.patch {
        defaultBash = "${defaultShell.bashWithDefaultShellUtils}/bin/bash";
      };
    })
    ./patches/build_execlog_parser.patch

    # --experimental_strict_action_env (which may one day become the default
    # see bazelbuild/bazel#2574) hardcodes the default
    # action environment to a non hermetic value (e.g. "/usr/local/bin").
    # This is non hermetic on non-nixos systems. On NixOS, bazel cannot find the required binaries.
    # So we are replacing this bazel paths by defaultShellPath,
    # improving hermeticity and making it work in nixos.
    (replaceVars ./patches/strict_action_env.patch {
      strictActionEnvPatch = defaultShell.defaultShellPath;
    })

    (replaceVars ./patches/default_bash.patch {
      defaultBash = "${defaultShell.bashWithDefaultShellUtils}/bin/bash";
    })

    # Provide default JRE for Bazel process by setting --server_javabase=
    # in a new default system bazelrc file
    (replaceVars ./patches/bazel_rc.patch {
      bazelSystemBazelRCPath = replaceVars ./system.bazelrc {
        serverJavabase = jdk_headless;
      };
    })
  ];
  commonDarwinPatches = [
    # Bazel integrates with apple IOKit to inhibit and track system sleep.
    # Inside the darwin sandbox, these API calls are blocked, and bazel
    # crashes. It seems possible to allow these APIs inside the sandbox, but it
    # feels simpler to patch bazel not to use it at all. So our bazel is
    # incapable of preventing system sleep, which is a small price to pay to
    # guarantee that it will always run in any nix context.
    #
    # See also ./bazel_darwin_sandbox.patch in bazel_5. That patch uses
    # NIX_BUILD_TOP env var to conditionnally disable sleep features inside the
    # sandbox.
    #
    # If you want to investigate the sandbox profile path,
    # IORegisterForSystemPower can be allowed with
    #
    #     propagatedSandboxProfile = ''
    #       (allow iokit-open (iokit-user-client-class "RootDomainUserClient"))
    #     '';
    #
    # I do not know yet how to allow IOPMAssertion{CreateWithName,Release}
    ./patches/darwin_sleep.patch

    # Fix DARWIN_XCODE_LOCATOR_COMPILE_COMMAND by removing multi-arch support.
    # Nixpkgs toolcahins do not support that (yet?) and get confused.
    # Also add an explicit /usr/bin prefix that will be patched below.
    (replaceVars ./patches/xcode.patch {
      clangDarwin = "${stdenv.cc}/bin/clang";
    })

  ];
in
rec {
  bazel8Info = {
    version = "8.5.0";
    hash = "sha256-L8gnWpQAeHMUbydrrEtZ6WGIzhunDBWCNWMA+3dAKT0=";

    examples = {
      javaFODHashes = {
        aarch64-darwin = "sha256-FVTyDxSYfcsK0f0/QiRVD3tkPEr6xpTJpATuuBe2Gb0=";
        aarch64-linux = "sha256-OPoV2hFgebgZCWaYD76cT5PSlmjCpSJNE366eumU3PA=";
        x86_64-darwin = "sha256-FWj/LiruyP6tyByx0mt782U5EtGqt+FxfXmRVFX5fC0=";
        x86_64-linux = "sha256-W/mrULm1wk9iRtns0yo8YPht2QGHQFpbvPRaAG/YK4A=";
      };

      cppFODHashes = {
        aarch64-darwin = "sha256-LrQy27ghyXhZFhDP//0GzDQzlwAPwJuvp82nUfUmMdM=";
        aarch64-linux = "sha256-LrQy27ghyXhZFhDP//0GzDQzlwAPwJuvp82nUfUmMdM=";
        x86_64-darwin = "sha256-LrQy27ghyXhZFhDP//0GzDQzlwAPwJuvp82nUfUmMdM=";
        x86_64-linux = "sha256-LrQy27ghyXhZFhDP//0GzDQzlwAPwJuvp82nUfUmMdM=";
      };

      rustFODHashes = {
        aarch64-darwin = "sha256-Tp36jLnw+2U2QANMNZZ01iLfYG2n8xJ/k2mDgL3tDU8=";
        aarch64-linux = "sha256-UhutemsgZE6FI9awHPZcGGcDkXzSUEYmAr1mHbjKC58=";
        x86_64-darwin = "sha256-fhGgDGDUOD75madRFzWT+pbUYsn0o1GBy907ClmP/Ac=";
        x86_64-linux = "sha256-5HoHlX3+0LMB/tWP3rFbaglp7sfJhhULdQaSLPcxFI8=";
      };
    };

    injectPackage =
      pkg:
      {
        bazel_8,
        callPackage,
      }:
      callPackage pkg {
        bazel_package = bazel_8;
        versionInfo = bazel8Info;
      };

    darwinPatches = [
      # Revert preference for apple_support over rules_cc toolchain for now
      # will need to figure out how to build with apple_support toolchain later
      ./patches/8/apple_cc_toolchain.patch

      # On Darwin, the last argument to gcc is coming up as an empty string. i.e: ''
      # This is breaking the build of any C target. This patch removes the last
      # argument if it's found to be an empty string.
      ./patches/8/trim-last-argument-to-gcc-if-empty.patch
    ]
    ++ commonDarwinPatches;

    patches = [
      # patch that propagates rules_* patches below
      # patches need to be within source root and can't be absolute paths in Nix store
      # so rules_* patches are injected via addFilePatch
      ./patches/8/deps_patches.patch
      (addFilePatch {
        path = "b/third_party/rules_python.patch";
        file = replaceVars ./patches/8/rules_python.patch {
          usrBinEnv = "${coreutils}/bin/env";
        };
      })
      # Part of suggestion for upstream in https://github.com/bazelbuild/bazel/pull/25934
      ./patches/8/env_bash.patch
      # Suggested for upstream in https://github.com/bazelbuild/bazel/pull/25935
      ./patches/8/gen_completion.patch

      (replaceVars ./patches/8/md5sum.patch {
        md5sum = "${coreutils}/bin/md5sum";
      })

      # Nix build sandbox can configure custom PATH but doesn't have
      # /usr/bin/env which is unfortunate https://github.com/NixOS/nixpkgs/issues/6227
      # and we need to do a silly patch
      (replaceVars ./patches/8/usr_bin_env.patch {
        usrBinEnv = "${coreutils}/bin/env";
      })
    ]
    ++ commonPatches;
  };

  bazel9Info = {
    version = "9.0.0";
    hash = "sha256-/veTQ/Fs5KKs58nJrazfLcJmwUWpP/m0d3tKfp34KmI=";

    examples = {
      javaFODHashes = {
        aarch64-darwin = "sha256-q3pqVkRwvrFD27M3B7gh+qf+2SEdPgTOeM0f3+l6SRg=";
        aarch64-linux = "sha256-IXKC4H9S1m9zGWOWjqGE6VMD+75Ab3LkPWawN3VDQCY=";
        x86_64-darwin = "sha256-gdoTVLHoPyA1oaLHcteTUbtUATkv6MYkkMXiBlTTcZc=";
        x86_64-linux = "sha256-Qr47mWJV6KqS4v+2eomaWZfPDdUS3ElY5mw4umZGdyo=";
      };

      cppFODHashes = {
        aarch64-darwin = "sha256-ue6o6lhEongecKPxqxTCDcZ5D6IhCLnFQ+OoziQl2OQ=";
        aarch64-linux = "sha256-ue6o6lhEongecKPxqxTCDcZ5D6IhCLnFQ+OoziQl2OQ=";
        x86_64-darwin = "sha256-ue6o6lhEongecKPxqxTCDcZ5D6IhCLnFQ+OoziQl2OQ=";
        x86_64-linux = "sha256-ue6o6lhEongecKPxqxTCDcZ5D6IhCLnFQ+OoziQl2OQ=";
      };

      rustFODHashes = {
        aarch64-darwin = "sha256-wJZo7ovyX6qRuA3uwUsCkeNl07sf2NP0EarN1WO/nrE=";
        aarch64-linux = "sha256-70T07+YFMOXxz80S8CQeQ7LZ7SLRusYQrzVEXnjxDmA=";
        x86_64-darwin = "sha256-a4mWZRZNs3Dv4MjMci+LpPeP66qA8HefcqxHtLeKWZg=";
        x86_64-linux = "sha256-F8ShFp/nPm7uXvhe5UMtrkp27HDUU/qiltxWlOzm4Vc=";
      };
    };

    injectPackage =
      pkg:
      {
        bazel_9,
        callPackage,
      }:
      callPackage pkg {
        bazel_package = bazel_9;
        versionInfo = bazel9Info;
      };

    darwinPatches = [
      # Revert preference for apple_support over rules_cc toolchain for now
      # will need to figure out how to build with apple_support toolchain later
      ./patches/9/apple_cc_toolchain.patch
    ]
    ++ commonDarwinPatches;

    patches = [
      # patch that propagates rules_* patches below
      # patches need to be within source root and can't be absolute paths in Nix store
      # so rules_* patches are injected via addFilePatch
      ./patches/9/deps_patches.patch
      (addFilePatch {
        path = "b/third_party/rules_python.patch";
        file = replaceVars ./patches/9/rules_python.patch {
          usrBinEnv = "${coreutils}/bin/env";
        };
      })

      (replaceVars ./patches/9/md5sum.patch {
        md5sum = "${coreutils}/bin/md5sum";
      })

      # Nix build sandbox can configure custom PATH but doesn't have
      # /usr/bin/env which is unfortunate https://github.com/NixOS/nixpkgs/issues/6227
      # and we need to do a silly patch
      (replaceVars ./patches/9/usr_bin_env.patch {
        usrBinEnv = "${coreutils}/bin/env";
      })
    ]
    ++ commonPatches;
  };

  "8" = bazel8Info;
  "9" = bazel9Info;
}
.${majorVersion}
