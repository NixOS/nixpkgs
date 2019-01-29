{ buildBazelPackage
, cacert
, fetchFromGitHub
, fetchpatch
, git
, go
, python
, stdenv
}:

buildBazelPackage rec {
  name = "bazel-watcher-${version}";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "bazel-watcher";
    rev = "v${version}";
    sha256 = "0yphks1qlp3xcbq5mg95lxrhl3q8pza5g3f9i2j6y7dsfz0s0l4v";
  };

  nativeBuildInputs = [ go git python ];

  bazelTarget = "//ibazel";

  fetchAttrs = {
    preBuild = ''
      patchShebangs .

      # tell rules_go to use the Go binary found in the PATH
      sed -e 's:go_register_toolchains():go_register_toolchains(go_version = "host"):g' -i WORKSPACE

      # tell rules_go to invoke GIT with custom CAINFO path
      export GIT_SSL_CAINFO="${cacert}/etc/ssl/certs/ca-bundle.crt"
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

    sha256 = "14k1cpw4h78c2gk294xzq9a9nv09yabdrahbzgin8xizbgdxn1q8";
  };

  buildAttrs = {
    preBuild = ''
      patchShebangs .

      # tell rules_go to use the Go binary found in the PATH
      sed -e 's:go_register_toolchains():go_register_toolchains(go_version = "host"):g' -i WORKSPACE
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
