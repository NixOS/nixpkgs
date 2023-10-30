{ lib
  # tooling
, callPackage
, fetchFromGitHub
, newScope
, recurseIntoAttrs
, runCommandCC
, stdenv
, fetchurl
  # inputs
, Foundation
, bazel_self
, lr
, xe
, bazel-watcher
, lockfile
, repoCache
}:
let
  inherit (stdenv.hostPlatform) isDarwin;

  testsDistDir = testsRepoCache;
  testsRepoCache = callPackage ./bazel-repository-cache.nix {
    # We are somewhat lucky that bazel's own lockfile works for our tests.
    # Use extraDeps if the tests need things that are not in that lockfile.
    # But most test dependencies are bazel's builtin deps, so that at least aligns.
    inherit lockfile;

    # Take all the rules_ deps, bazel_ deps and their transitive dependencies,
    # but none of the platform-specific binaries, as they are large and useless.
    requiredDepNamePredicate = name:
      null == builtins.match ".*(macos|osx|linux|win|apple|android|maven).*" name
      && null != builtins.match "(platforms|com_google_|protobuf|rules_|bazel_).*" name ;
  };

  runLocal = name: attrs: script:
    let
      attrs' = removeAttrs attrs [ "buildInputs" ];
      buildInputs = attrs.buildInputs or [ ];
    in
    runCommandCC name
      ({
        inherit buildInputs;
        preferLocalBuild = true;
        meta.platforms = bazel_self.meta.platforms;
      } // attrs')
      script;

  # bazel wants to extract itself into $install_dir/install every time it runs,
  # so let’s do that only once.
  extracted = bazelPkg:
    let
      install_dir =
        # `install_base` field printed by `bazel info`, minus the hash.
        # yes, this path is kinda magic. Sorry.
        "$HOME/.cache/bazel/_bazel_nixbld";
    in
    runLocal "bazel-extracted-homedir" { passthru.install_dir = install_dir; } ''
      export HOME=$(mktemp -d)
      touch WORKSPACE # yeah, everything sucks
      install_base="$(${bazelPkg}/bin/bazel info install_base)"
      # assert it’s actually below install_dir
      [[ "$install_base" =~ ${install_dir} ]] \
        || (echo "oh no! $install_base but we are \
      trying to copy ${install_dir} to $out instead!"; exit 1)
      cp -R ${install_dir} $out
    '';

  bazelTest = { name, bazelScript, workspaceDir, bazelPkg, buildInputs ? [ ] }:
    runLocal name
      {
        inherit buildInputs;
        # Necessary for the tests to pass on Darwin with sandbox enabled.
        __darwinAllowLocalNetworking = true;
      }
      ''
        # Bazel needs a real home for self-extraction and internal cache
        mkdir bazel_home
        export HOME=$PWD/bazel_home

        ${# Concurrent bazel invocations have the same workspace path.
          # On darwin, for some reason, it means they access and corrupt the
          # same outputRoot, outputUserRoot and outputBase
          # Ensure they use build-local outputRoot by setting TEST_TMPDIR
          lib.optionalString isDarwin ''
            export TEST_TMPDIR=$HOME/.cache/bazel
          ''
        }
        ${# Speed-up tests by caching bazel extraction.
          # Except on Darwin, because nobody knows how Darwin works.
          let bazelExtracted = extracted bazelPkg;
          in lib.optionalString (!isDarwin) ''
            mkdir -p ${bazelExtracted.install_dir}
            cp -R ${bazelExtracted}/install ${bazelExtracted.install_dir}

            # https://stackoverflow.com/questions/47775668/bazel-how-to-skip-corrupt-installation-on-centos6
            # Bazel checks whether the mtime of the install dir files
            # is >9 years in the future, otherwise it extracts itself again.
            # see PosixFileMTime::IsUntampered in src/main/cpp/util
            # What the hell bazel.
            ${lr}/bin/lr -0 -U ${bazelExtracted.install_dir} | ${xe}/bin/xe -N0 -0 touch --date="9 years 6 months" {}
          ''
        }
        ${# Note https://github.com/bazelbuild/bazel/issues/5763#issuecomment-456374609
          # about why to create a subdir for the workspace.
          '' cp -r ${workspaceDir} wd && chmod ug+rw -R wd && cd wd ''
        }
        ${# run the actual test snippet
          bazelScript
        }
        ${# Try to keep darwin clean of our garbage
          lib.optionalString isDarwin ''
            rm -rf $HOME || true
          ''
        }

        touch $out
      '';

  bazel-examples = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "examples";
    rev = "93564e1f1e7a3c39d6a94acee12b8d7b74de3491";
    hash = "sha256-DaPKp7Sn5uvfZRjdDx6grot3g3B7trqCyL0TRIdwg98=";
  };

  callBazelTests = args:
    let
      callBazelTest = newScope {
        inherit runLocal bazelTest bazel-examples;
        inherit Foundation;
        bazel = bazel_self;
        distDir = testsDistDir;
        extraBazelArgs = ''
          --noenable_bzlmod \
        '';
      };
    in
    recurseIntoAttrs (
      (lib.optionalAttrs (!isDarwin) {
        # `extracted` doesn’t work on darwin
        shebang = callBazelTest ../shebang-test.nix (args // { inherit extracted; });
      }) // {
      bashTools = callBazelTest ../bash-tools-test.nix args;
      cpp = callBazelTest ../cpp-test.nix args;
      java = callBazelTest ../java-test.nix args;
      pythonBinPath = callBazelTest ../python-bin-path-test.nix args;
      protobuf = callBazelTest ./protobuf-test.nix (args // { repoCache = testsRepoCache; });
    });

  bazelWithNixHacks = bazel_self.override { enableNixHacks = true; };

in
recurseIntoAttrs {
  distDir = testsDistDir;
  testsRepoCache = testsRepoCache;

  vanilla = callBazelTests { };
  withNixHacks = callBazelTests { bazel = bazelWithNixHacks; };

  # downstream packages using buildBazelPackage
  # fixed-output hashes of the fetch phase need to be spot-checked manually
  downstream = recurseIntoAttrs ({
    inherit bazel-watcher;
  });
}

