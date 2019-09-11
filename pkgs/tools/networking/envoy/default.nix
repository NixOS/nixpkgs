{ stdenv, lib, fetchFromGitHub, pkgconfig, buildBazelPackage, git
, go, autoconf, automake, cmake, libtool, python, ninja
}:

buildBazelPackage rec {
  name = "envoy-${version}";
  version = "1.11.1";
  rev = "e349fb6139e4b7a59a9a359be0ea45dd61e589c5";

  src = fetchFromGitHub {
    owner = "envoyproxy";
    repo = "envoy";
    rev = "v${version}";
    sha256 = "09mgb5xlxws8w379wrw1fw5w7adgpsnj5zwa9f1cbwqjdxgzjhg4";
  };

  nativeBuildInputs = [ autoconf automake cmake git go libtool ninja python ];

  bazelTarget = "//source/exe:envoy";

  dontUseCmakeConfigure = true;

  fetchAttrs = {
    preBuild = ''
      patchShebangs .

      # tell rules_go to use the Go binary found in the PATH
      sed -e 's:go_register_toolchains(go_version = GO_VERSION):go_register_toolchains(go_version = "host"):g' -i WORKSPACE
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

      # Remove the autoconf caches
      rm -rf $bazelOut/external/com_github_gperftools_gperftools/autom4te.cache
      sed -e '/^FILE:@com_github_gperftools_gperftools/autom4te.cache.*/d' -i $bazelOut/external/\@*.marker
    '';

    sha256 = "1sq8qdbg8f94dbyc607xpq2yrhw61j3yxq6kggywp6fbbg89fh55";
  };

  buildAttrs = {
    preBuild = ''
      patchShebangs .
      patchShebangs $bazelOut/external

      # pass in the commit explicitly so it doesn't try to use git to find it out
      # this has to be the commit id and not any other string as it is passed to
      # the linker via --build-id
      cat > SOURCE_VERSION <<EOF
      ${rev}
      EOF

      # pass in the paths to rules_foreign_cc as custom toolchains to work around
      # https://github.com/bazelbuild/rules_foreign_cc/issues/225
      cat >> BUILD <<EOF
      load("@rules_foreign_cc//tools/build_defs/native_tools:native_tools_toolchain.bzl", "native_tool_toolchain")

      native_tool_toolchain(
          name = "nix_cmake",
          path = "${cmake}/bin/cmake",
          visibility = ["//visibility:public"],
      )
      toolchain(
          name = "nix_cmake_toolchain",
          toolchain = ":nix_cmake",
          toolchain_type = "@rules_foreign_cc//tools/build_defs:cmake_toolchain",
      )

      native_tool_toolchain(
          name = "nix_ninja",
          path = "${ninja}/bin/ninja",
          visibility = ["//visibility:public"],
      )
      toolchain(
          name = "nix_ninja_toolchain",
          toolchain = ":nix_ninja",
          toolchain_type = "@rules_foreign_cc//tools/build_defs:ninja_toolchain",
      )
      EOF

      sed -e 's;rules_foreign_cc_dependencies();rules_foreign_cc_dependencies(["//:nix_cmake_toolchain", "//:nix_ninja_toolchain"]);g' -i WORKSPACE

      # tell rules_go to use the Go binary found in the PATH
      sed -e 's;go_register_toolchains(go_version = GO_VERSION);go_register_toolchains(go_version = "host");g' -i WORKSPACE

    '';

    installPhase = ''
      mkdir -p $out/bin
      mv bazel-bin/source/exe/envoy-static $out/bin/envoy
    '';
  };

  meta = with lib; {
    description = "Cloud-native high-performance edge/middle/service proxy";
    homepage = "https://www.envoyproxy.io/";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ];
  };
}
