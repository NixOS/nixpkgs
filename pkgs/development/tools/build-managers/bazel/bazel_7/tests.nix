{ lib
  # tooling
, fetchFromGitHub
, newScope
, runCommandCC
, stdenv
  # inputs
, Foundation
, bazel_self
, distDir
, lr
, repoCache
, runJdk
, xe
}:
let
  inherit (stdenv.hostPlatform) isDarwin;

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
        export HOME=$(mktemp -d)

        ${# Concurrent bazel invocations have the same workspace path.
          # On darwin, for some reason, it means they access and corrupt the same execroot.
          # Having a different workspace path ensures we use different execroots.
          # A different user seems to be enough for a different bazel cache root.
          lib.optionalString isDarwin ''
            export USER=$(basename $HOME)
            # cd $(mktemp --tmpdir=. -d)
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
          '' cp -r ${workspaceDir} wd && chmod u+w wd && cd wd ''
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

  callBazelTest = newScope {
    inherit runLocal bazelTest bazel-examples distDir;
    inherit Foundation;
    extraBazelArgs = ''
      --repository_cache=${repoCache} \
      --repo_env=JAVA_HOME=${runJdk}${if isDarwin then "/zulu-17.jdk/Contents/Home" else "/lib/openjdk"} \
    '';
    bazel = bazel_self;
  };

  bazelWithNixHacks = bazel_self.override { enableNixHacks = true; };

in
(lib.optionalAttrs (!stdenv.hostPlatform.isDarwin) {
  # `extracted` doesn’t work on darwin
  shebang = callBazelTest ../shebang-test.nix { inherit extracted; };
}) // {
  bashTools = callBazelTest ../bash-tools-test.nix { };
  cpp = callBazelTest ../cpp-test.nix { };
  java = callBazelTest ../java-test.nix { };
  # TODO: protobuf tests just fail for now.
  #protobuf = callBazelTest ../protobuf-test.nix { };
  pythonBinPath = callBazelTest ../python-bin-path-test.nix { };

  bashToolsWithNixHacks = callBazelTest ../bash-tools-test.nix { bazel = bazelWithNixHacks; };

  cppWithNixHacks = callBazelTest ../cpp-test.nix { bazel = bazelWithNixHacks; };
  javaWithNixHacks = callBazelTest ../java-test.nix { bazel = bazelWithNixHacks; };
  #protobufWithNixHacks = callBazelTest ../protobuf-test.nix { bazel = bazelWithNixHacks; };
  pythonBinPathWithNixHacks = callBazelTest ../python-bin-path-test.nix { bazel = bazelWithNixHacks; };

  # downstream packages using buildBazelPackage
  # fixed-output hashes of the fetch phase need to be spot-checked manually
  # TODO
  #downstream = recurseIntoAttrs ({
  #  inherit bazel-watcher;
  #});
}

