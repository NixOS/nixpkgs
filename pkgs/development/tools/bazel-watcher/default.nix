{ buildBazelPackage
, fetchFromGitHub
, git
, go
, python
, stdenv
}:

let
  patches = [
    ./use-go-in-path.patch
  ];
in
buildBazelPackage rec {
  name = "bazel-watcher-${version}";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "bazel-watcher";
    rev = "v${version}";
    sha256 = "0n28q27510ymg5d455hrbk7z8wawszgjmqjjhb4zximqhvxks7kh";
  };

  nativeBuildInputs = [ go git python ];
  removeRulesCC = false;

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

      # Retains go build input markers
      chmod -R 755 $bazelOut/external/{bazel_gazelle_go_repository_cache,@\bazel_gazelle_go_repository_cache.marker}
      rm -rf $bazelOut/external/{bazel_gazelle_go_repository_cache,@\bazel_gazelle_go_repository_cache.marker}

      # Remove the gazelle tools, they contain go binaries that are built
      # non-deterministically. As long as the gazelle version matches the tools
      # should be equivalent.
      rm -rf $bazelOut/external/{bazel_gazelle_go_repository_tools,\@bazel_gazelle_go_repository_tools.marker}
      sed -e '/^FILE:@bazel_gazelle_go_repository_tools.*/d' -i $bazelOut/external/\@*.marker
    '';

    sha256 = "0rfdwss8aahydiybwhi3j0qw12j1l91k9lbn1vaip0bmnq5qfwh9";
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
    homepage = "https://github.com/bazelbuild/bazel-watcher";
    description = "Tools for building Bazel targets when source files change.";
    license = licenses.asl20;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.all;
  };
}
