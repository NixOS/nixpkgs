{ buildBazelPackage
, bazel_5
, fetchFromGitHub
, git
, go
, python3
, lib, stdenv
}:

let
  patches = [
    ./use-go-in-path.patch
    ./fix-rules-go-3408.patch
  ];

  # Patch the protoc alias so that it always builds from source.
  rulesProto = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "rules_proto";
    rev = "4.0.0-3.19.2";
    sha256 = "sha256-wdmp+Tmf63PPr7G4X5F7rDas45WEETU3eKb47PFVI6o=";
    postFetch = ''
      sed -i 's|name = "protoc"|name = "_protoc_original"|' $out/proto/private/BUILD.release
      cat <<EOF >>$out/proto/private/BUILD.release
      alias(name = "protoc", actual = "@com_github_protocolbuffers_protobuf//:protoc", visibility = ["//visibility:public"])
      EOF
    '';
  };

in
buildBazelPackage rec {
  pname = "bazel-watcher";
  version = "0.21.2";

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "bazel-watcher";
    rev = "v${version}";
    sha256 = "sha256-wigrE9u1VuFnqLWyVJK3M7xsjyme2dDG6YTcD9whKnw=";
  };

  nativeBuildInputs = [ go git python3 ];
  removeRulesCC = false;

  bazel = bazel_5;
  bazelFlags = [ "--override_repository=rules_proto=${rulesProto}" ];
  bazelBuildFlags = lib.optionals stdenv.cc.isClang [ "--cxxopt=-x" "--cxxopt=c++" "--host_cxxopt=-x" "--host_cxxopt=c++" ];
  bazelTarget = "//cmd/ibazel";

  fetchConfigured = false; # we want to fetch all dependencies, regardless of the current system
  fetchAttrs = {
    inherit patches;

    preBuild = ''
      patchShebangs .

      echo ${bazel_5.version} > .bazelversion
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

      # remove com_google_protobuf because it had files with different permissions on linux and darwin
      rm -rf $bazelOut/external/com_google_protobuf
    '';

    sha256 = "sha256-le8IepS+IGVX45Gj1aicPjYOkuUA+VVUy/PEeKLNYss=";
  };

  buildAttrs = {
    inherit patches;

    preBuild = ''
      patchShebangs .

      substituteInPlace cmd/ibazel/BUILD.bazel --replace '{STABLE_GIT_VERSION}' ${version}
      echo ${bazel_5.version} > .bazelversion
    '';

    installPhase = ''
      install -Dm755 bazel-bin/cmd/ibazel/ibazel_/ibazel $out/bin/ibazel
    '';
  };

  meta = with lib; {
    homepage = "https://github.com/bazelbuild/bazel-watcher";
    description = "Tools for building Bazel targets when source files change";
    license = licenses.asl20;
    maintainers = with maintainers; [ kalbasit ];
    mainProgram = "ibazel";
    platforms = platforms.all;
  };
}
