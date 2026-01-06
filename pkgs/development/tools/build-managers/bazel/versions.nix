{
  stdenv,
  coreutils,
  replaceVars,
  majorVersion,
  defaultShell,
  jdk_headless,
  addFilePatch,
}:
{

  "8" = {
    version = "8.5.0";
    hash = "sha256-L8gnWpQAeHMUbydrrEtZ6WGIzhunDBWCNWMA+3dAKT0=";

    injectPackage = pkg: { bazel_8, callPackage }: callPackage pkg { bazel_package = bazel_8; };

    darwinPatches = [
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

      # Revert preference for apple_support over rules_cc toolchain for now
      # will need to figure out how to build with apple_support toolchain later
      ./patches/apple_cc_toolchain.patch

      # On Darwin, the last argument to gcc is coming up as an empty string. i.e: ''
      # This is breaking the build of any C target. This patch removes the last
      # argument if it's found to be an empty string.
      ./patches/trim-last-argument-to-gcc-if-empty.patch
    ];

    patches = [
      # patch that propagates rules_* patches below
      # patches need to be within source root and can't be absolute paths in Nix store
      # so rules_* patches are injected via addFilePatch
      ./patches/deps_patches.patch
      (addFilePatch {
        path = "b/third_party/rules_python.patch";
        file = replaceVars ./patches/rules_python.patch {
          usrBinEnv = "${coreutils}/bin/env";
        };
      })
      (addFilePatch {
        path = "b/third_party/rules_java.patch";
        file = replaceVars ./patches/rules_java.patch {
          defaultBash = "${defaultShell.bashWithDefaultShellUtils}/bin/bash";
        };
      })
      # Suggested for upstream in https://github.com/bazelbuild/bazel/pull/25936
      ./patches/build_execlog_parser.patch
      # Part of suggestion for upstream in https://github.com/bazelbuild/bazel/pull/25934
      ./patches/env_bash.patch
      # Suggested for upstream in https://github.com/bazelbuild/bazel/pull/25935
      ./patches/gen_completion.patch

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

      (replaceVars ./patches/md5sum.patch {
        md5sum = "${coreutils}/bin/md5sum";
      })

      # Nix build sandbox can configure custom PATH but doesn't have
      # /usr/bin/env which is unfortunate https://github.com/NixOS/nixpkgs/issues/6227
      # and we need to do a silly patch
      (replaceVars ./patches/usr_bin_env.patch {
        usrBinEnv = "${coreutils}/bin/env";
      })

      # Provide default JRE for Bazel process by setting --server_javabase=
      # in a new default system bazelrc file
      (replaceVars ./patches/bazel_rc.patch {
        bazelSystemBazelRCPath = replaceVars ./system.bazelrc {
          serverJavabase = jdk_headless;
        };
      })
    ];
  };
}
.${majorVersion}
