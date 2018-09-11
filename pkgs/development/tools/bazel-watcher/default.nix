{ buildBazelPackage
, fetchFromGitHub
, stdenv
, cacert
, go
, git
}:

buildBazelPackage rec {
  name = "bazel-watcher-${version}";
  version = "2018-09-09";

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "bazel-watcher";
    rev = "4d5928eee3dd5843a1b55136d914b78fef7f25d0";
    sha256 = "1v4mr85j3j458880n7vpkc4r4ws75pgbq54l5lrsrfi0rcbin6r5";
  };

  patches = [ ./update-gazelle-fix-ssl.patch ];

  nativeBuildInputs = [ go git ];

  bazelTarget = "//ibazel";

  fetchAttrs = {
    preBuild = ''
      patchShebangs .

      # tell rules_go to use the Go binary found in the system
      sed -e 's:go_register_toolchains():go_register_toolchains(go_version = "host"):g' -i WORKSPACE

      # tell rules_go to invoke GIT with custom CAINFO path
      export GIT_SSL_CAINFO="${cacert}/etc/ssl/certs/ca-bundle.crt"
    '';

    preInstall = ''
      # Remove all built in external workspaces, Bazel will recreate them when building
      rm -rf $bazelOut/external/{bazel_tools,\@bazel_tools.marker}
      rm -rf $bazelOut/external/{embedded_jdk,\@embedded_jdk.marker}
      rm -rf $bazelOut/external/{go_sdk,\@go_sdk.marker}
      rm -rf $bazelOut/external/{local_*,\@local_*}
    '';

    sha256 = "0m7sjlbhg3p3l3mhs5smd28mj3zyzf6jrk3dgg0mjfb3zwfnfz32";
  };

  buildAttrs = {
    preBuild = ''
      patchShebangs .

      # tell rules_go to use the Go binary found in the system
      sed -e 's:go_register_toolchains():go_register_toolchains(go_version = "host"):g' -i WORKSPACE
    '';

    installPhase = ''
      install -Dm755 bazel-bin/ibazel/*_pure_stripped/ibazel $out/bin/ibazel
    '';
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/bazelbuild/bazel-watcher;
    description = "Tools for building Bazel targets when source files change.";
    license = licenses.asl20 ;
    maintainers = [ maintainers.kalbasit ];
    platforms = platforms.all;
  };
}
