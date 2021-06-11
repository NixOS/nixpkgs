{ lib
, buildBazelPackage
, fetchFromGitHub
, stdenv
, cmake
, gn
, go
, jdk
, ninja
, python3
, nixosTests
}:

let
  srcVer = {
    # We need the commit hash, since Bazel stamps the build with it.
    # However, the version string is more useful for end-users.
    # These are contained in a attrset of their own to make it obvious that
    # people should update both.
    version = "1.17.3";
    commit = "46bf743b97d0d3f01ff437b2f10cc0bd9cdfe6e4";
  };
in
buildBazelPackage rec {
  pname = "envoy";
  version = srcVer.version;
  src = fetchFromGitHub {
    owner = "envoyproxy";
    repo = "envoy";
    rev = srcVer.commit;
    hash = "sha256:09zzr4h3zjsb2rkxrvlazpx0jy33yn9j65ilxiqbvv0ckaralqfc";

    extraPostFetch = ''
      chmod -R +w $out
      rm $out/.bazelversion
      echo ${srcVer.commit} > $out/SOURCE_VERSION
      sed -i 's/GO_VERSION = ".*"/GO_VERSION = "host"/g' $out/bazel/dependency_imports.bzl
    '';
  };

  postPatch = ''
    sed -i 's,#!/usr/bin/env python3,#!${python3}/bin/python,' bazel/foreign_cc/luajit.patch
    sed -i '/javabase=/d' .bazelrc
    # Patch paths to build tools, and disable gold because it just segfaults.
    substituteInPlace bazel/external/wee8.genrule_cmd \
      --replace '"''$$gn"' '"''$$(command -v gn)"' \
      --replace '"''$$ninja"' '"''$$(command -v ninja)"' \
      --replace '"''$$WEE8_BUILD_ARGS"' '"''$$WEE8_BUILD_ARGS use_gold=false"'
  '';

  nativeBuildInputs = [
    cmake
    python3
    gn
    go
    jdk
    ninja
  ];

  fetchAttrs = {
    sha256 = "sha256:1cy2b73x8jzczq9z9c1kl7zrg5iasvsakb50zxn4mswpmajkbj5h";
    dontUseCmakeConfigure = true;
    dontUseGnConfigure = true;
    preInstall = ''
      # Strip out the path to the build location (by deleting the comment line).
      find $bazelOut/external -name requirements.bzl | while read requirements; do
        sed -i '/# Generated from /d' "$requirements"
      done

      # Remove references to paths in the Nix store.
      sed -i \
        -e 's,${python3},__NIXPYTHON__,' \
        -e 's,${stdenv.shellPackage},__NIXSHELL__,' \
        $bazelOut/external/com_github_luajit_luajit/build.py \
        $bazelOut/external/local_config_sh/BUILD
      rm -r $bazelOut/external/go_sdk

      # Replace some wheels which are only used for tests with empty files;
      # they're nondeterministically built and packed.
      >$bazelOut/external/config_validation_pip3/PyYAML-5.3.1-cp38-cp38-linux_x86_64.whl
      >$bazelOut/external/protodoc_pip3/PyYAML-5.3.1-cp38-cp38-linux_x86_64.whl
      >$bazelOut/external/thrift_pip3/thrift-0.13.0-cp38-cp38-linux_x86_64.whl

      # Remove Unix timestamps from go cache.
      rm -rf $bazelOut/external/bazel_gazelle_go_repository_cache/{gocache,pkg/mod/cache,pkg/sumdb}
    '';
  };
  buildAttrs = {
    dontUseCmakeConfigure = true;
    dontUseGnConfigure = true;
    dontUseNinjaInstall = true;
    preConfigure = ''
      sed -i 's,#!/usr/bin/env bash,#!${stdenv.shell},' $bazelOut/external/rules_foreign_cc/tools/build_defs/framework.bzl

      # Add paths to Nix store back.
      sed -i \
        -e 's,__NIXPYTHON__,${python3},' \
        -e 's,__NIXSHELL__,${stdenv.shellPackage},' \
        $bazelOut/external/com_github_luajit_luajit/build.py \
        $bazelOut/external/local_config_sh/BUILD
    '';
    installPhase = ''
      install -Dm0755 bazel-bin/source/exe/envoy-static $out/bin/envoy
    '';
  };

  removeRulesCC = false;
  removeLocalConfigCc = true;
  removeLocal = false;
  bazelTarget = "//source/exe:envoy-static";
  bazelBuildFlags = [
    "-c opt"
    "--spawn_strategy=standalone"
    "--noexperimental_strict_action_env"
    "--cxxopt=-Wno-maybe-uninitialized"
    "--cxxopt=-Wno-uninitialized"
  ];

  passthru.tests = {
    # No tests for Envoy itself (yet), but it's tested as a core component of Pomerium.
    inherit (nixosTests) pomerium;
  };

  meta = with lib; {
    homepage = "https://envoyproxy.io";
    description = "Cloud-native edge and service proxy";
    license = licenses.asl20;
    maintainers = with maintainers; [ lukegb ];
    platforms = [ "x86_64-linux" ];  # Other platforms will generate different fetch hashes.
  };
}
