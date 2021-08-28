{ buildBazelPackage
, fetchFromGitHub
, git
, go
, python3
, lib, stdenv
}:

let
  patches = [
    ./use-go-in-path.patch
  ];
in
buildBazelPackage rec {
  name = "bazel-watcher-${version}";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "bazel-watcher";
    rev = "v${version}";
    sha256 = "0gigl1lg8sb4bj5crvj54329ws4yirldbncs15f96db6vhp0ig7r";
  };

  nativeBuildInputs = [ go git python3 ];
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

    sha256 = "0rwwjjj6zaj4hdcbsbp0di53xn6203r2vgpddhdrp8iph9ab60cg";
  };

  buildAttrs = {
    inherit patches;

    preBuild = ''
      patchShebangs .

      substituteInPlace ibazel/BUILD --replace '{STABLE_GIT_VERSION}' ${version}
    '';

    installPhase = ''
      install -Dm755 bazel-bin/ibazel/*_pure_stripped/ibazel $out/bin/ibazel
    '';
  };

  meta = with lib; {
    homepage = "https://github.com/bazelbuild/bazel-watcher";
    description = "Tools for building Bazel targets when source files change";
    license = licenses.asl20;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.all;
    # broken on darwin, see https://github.com/NixOS/nixpkgs/issues/105573
    broken = stdenv.isDarwin;
  };
}
