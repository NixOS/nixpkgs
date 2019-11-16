{ buildBazelPackage
, cacert
, fetchFromGitHub
, git
, go
, stdenv
}:

buildBazelPackage rec {
  name = "bazel-remote-${version}";
  version = "2019-01-12";

  src = fetchFromGitHub {
    owner = "buchgr";
    repo = "bazel-remote";
    rev = "3f65b6ccf69e223950c77275a743d0d3a04a8583";
    sha256 = "0fklrlylmc55yzhm3m1f211x5gmk7hpqjb7k5kml7n3gw3npbjda";
  };

  nativeBuildInputs = [ go git ];

  bazelTarget = "//:bazel-remote";

  fetchAttrs = {
    preBuild = ''
      patchShebangs .

      # tell rules_go to use the Go binary found in the PATH
      sed -e 's:go_register_toolchains():go_register_toolchains(go_version = "host"):g' -i WORKSPACE

      # update gazelle to work around https://github.com/golang/go/issues/29850
      sed -e 's,https://github.com/bazelbuild/bazel-gazelle/releases/download/0.15.0/bazel-gazelle-0.15.0.tar.gz,https://github.com/bazelbuild/bazel-gazelle/releases/download/0.16.0/bazel-gazelle-0.16.0.tar.gz,g' -i WORKSPACE
      sed -e 's,6e875ab4b6bf64a38c352887760f21203ab054676d9c1b274963907e0768740d,7949fc6cc17b5b191103e97481cf8889217263acf52e00b560683413af204fcb,g' -i WORKSPACE

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

    sha256 = "1wvyv3w5y6vj6qs6v5qyd356j1lxc3mf7n3j2pcib1bqmx3igw35";
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
    platforms = platforms.darwin;
    broken = true; # global variable '_layer' is referenced before assignment.
  };
}
