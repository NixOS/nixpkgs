{ buildBazelPackage
, cacert
, fetchFromGitHub
, git
, go
, stdenv
}:

buildBazelPackage rec {
  name = "bazel-remote-${version}";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "buchgr";
    repo = "bazel-remote";
    rev = "v${version}";
    sha256 = "1fpdw139d5q1377qnqbgkahmdr4mdaa17d2m10wkyvyvijwm4r2m";
  };

  nativeBuildInputs = [ go git ];

  bazelTarget = "//:bazel-remote";

  removeRulesCC = false;

  # this is to work around `test -f` failing when called by gazelle
  # https://github.com/bazelbuild/bazel-gazelle/blob/v0.19.1/internal/go_repository.bzl#L135
  patches = [ ./disable_build_file_generation.patch ];

  fetchAttrs = {
    preBuild = ''
      patchShebangs .

      # tell rules_go to use the Go binary found in the PATH
      sed -e 's:go_register_toolchains():go_register_toolchains(go_version = "host"):g' -i WORKSPACE

      # tell rules_go to invoke GIT with custom CAINFO path
      export GIT_SSL_CAINFO="${cacert}/etc/ssl/certs/ca-bundle.crt"

      # force gazelle to use the nix go cache rather than its own
      # export GO_REPOSITORY_USE_HOST_CACHE=1
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

      # Remove the gazelle repository cache as it contains built binaries
      chmod -R u+w $bazelOut/external/bazel_gazelle_go_repository_cache
      rm -rf $bazelOut/external/{bazel_gazelle_go_repository_cache,\@bazel_gazelle_go_repository_cache.marker}
      sed -e '/^FILE:@bazel_gazelle_go_repository_cache.*/d' -i $bazelOut/external/\@*.marker

      # Remove the gazelle tools, they contain go binaries that are built
      # non-deterministically. As long as the gazelle version matches the tools
      # should be equivalent.
      rm -rf $bazelOut/external/{bazel_gazelle_go_repository_tools,\@bazel_gazelle_go_repository_tools.marker}
      sed -e '/^FILE:@bazel_gazelle_go_repository_tools.*/d' -i $bazelOut/external/\@*.marker
    '';

    sha256 = "141kw2zpr612xdcrg6x9kslg4d5b3fbpzx0vgp3lqwdihfj3sc1l";
  };

  buildAttrs = {
    preBuild = ''
      patchShebangs .

      # tell rules_go to use the Go binary found in the PATH
      sed -e 's:go_register_toolchains():go_register_toolchains(go_version = "host"):g' -i WORKSPACE
    '';

    installPhase = ''
      install -Dm755 bazel-bin/*_pure_stripped/bazel-remote $out/bin/bazel-remote
    '';
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/buchgr/bazel-remote;
    description = "A remote HTTP/1.1 cache for Bazel.";
    license = licenses.asl20;
    maintainers = [ maintainers.uri-canva ];
    platforms = platforms.darwin ++ platforms.linux;
  };
}
