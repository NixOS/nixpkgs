{ buildBazelPackage
, fetchFromGitHub
, fetchpatch
, git
, go
, python
, stdenv
}:

let
  patches = [
    ./use-go-in-path.patch

    # update rules_go to fix the build. Remove these when updating past 0.10.3
    (fetchpatch {
      url = "https://github.com/bazelbuild/bazel-watcher/commit/686130f50cea274f7453f6abc8c5249654047462.patch";
      sha256 = "0rzs01sfiinl5d3dq9sx1bhl8kkzppdwh964fr7bzafqcxv5llmb";
    })
    (fetchpatch {
      url = "https://github.com/bazelbuild/bazel-watcher/commit/18bdb44832ccc533e0ab3923ef80060eeb24582d.patch";
      sha256 = "0k5hvlxlg4n092d53cbfxqqhzc6f1jv4licdhhi1dhckkhb4sdk6";
    })
  ];
in
buildBazelPackage rec {
  name = "bazel-watcher-${version}";
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "bazel-watcher";
    rev = "v${version}";
    sha256 = "17z4nqqsdrainbh8fmhf6sgrxwf7aknadmn94z1yqpxa7kb9x33v";
  };

  nativeBuildInputs = [ go git python ];

  bazelTarget = "//ibazel";

  fetchAttrs = {
    inherit patches;

    preBuild = ''
      patchShebangs .
    '';

    preInstall = ''
      # Remove the go_sdk (it's just a copy of the go derivation) and all
      # references to it from the marker files. Bazel does not need to download
      # this sdk because we have patched the WORKSPACE file to point to the one
      # currently present in PATH. Without removing the go_sdk from the marker
      # file, the hash of it will change anytime the Go derivation changes and
      # that would lead to impurities in the marker files which would result in
      # a different sha256 for the fetch phase.
      rm -rf $bazelOut/external/{go_sdk,\@go_sdk.marker}
      sed -e '/^FILE:@go_sdk.*/d' -i $bazelOut/external/\@*.marker

      # Remove the gazelle tools, they contain go binaries that are built
      # non-deterministically. As long as the gazelle version matches the tools
      # should be equivalent.
      rm -rf $bazelOut/external/{bazel_gazelle_go_repository_tools,\@bazel_gazelle_go_repository_tools.marker}
      sed -e '/^FILE:@bazel_gazelle_go_repository_tools.*/d' -i $bazelOut/external/\@*.marker
    '';

    sha256 = "0cmj186n2y1g9kkdhcivmh2qvigvpnbp03m575b7hgsxi1cp3ssj";
  };

  buildAttrs = {
    inherit patches;

    preBuild = ''
      patchShebangs .
    '';

    installPhase = ''
      install -Dm755 bazel-bin/ibazel/*_pure_stripped/ibazel $out/bin/ibazel
    '';
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/bazelbuild/bazel-watcher;
    description = "Tools for building Bazel targets when source files change.";
    license = licenses.asl20;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.all;
  };
}
