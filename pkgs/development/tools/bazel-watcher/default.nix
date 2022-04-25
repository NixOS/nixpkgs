{ buildBazelPackage, bazel_5
, fetchFromGitHub
, git
, go
, libcxx
, python3
, lib, stdenv
}:

let
  patches = [
    ./use-go-in-path.patch
  ];
in
buildBazelPackage rec {
  pname = "bazel-watcher";
  version = "0.16.2";

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "bazel-watcher";
    rev = "v${version}";
    sha256 = "sha256-yRXta6pPhgIonTL0q9GSzNQg/jHMIeC7xvfVYrZMmnc=";
  };

  nativeBuildInputs = [ go git python3 ];
  removeRulesCC = false;

  bazel = bazel_5;
  bazelTarget = "//ibazel";

  fetchAttrs = {
    inherit patches;

    preBuild = ''
      patchShebangs .

      rm .bazelversion
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

    sha256 = "sha256-LW5LJMS94D28SXDQB5ZHZ8RDHe3y6g+AN/4irJF3mOc=";
  };

  buildAttrs = {
    inherit patches;

    preBuild = lib.optionalString stdenv.hostPlatform.isDarwin ''
      export BAZEL_CXXOPTS="-I${lib.getDev libcxx}/include/c++/v1"
    '' + ''
      patchShebangs .

      rm .bazelversion
      substituteInPlace ibazel/BUILD --replace '{STABLE_GIT_VERSION}' ${version}
    '';

    installPhase = ''
      install -Dm755 bazel-bin/ibazel/ibazel_/ibazel $out/bin/ibazel
    '';
  };

  meta = with lib; {
    homepage = "https://github.com/bazelbuild/bazel-watcher";
    description = "Tools for building Bazel targets when source files change";
    license = licenses.asl20;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.all;
  };
}
