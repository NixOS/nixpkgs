{ lib
, bazel_4
, buildBazelPackage
, fetchFromGitHub
, fetchpatch
, stdenv
, cmake
, gn
, go
, jdk
, ninja
, python3
, linuxHeaders
, nixosTests

# v8 (upstream default), wavm, wamr, wasmtime, disabled
, wasmRuntime ? "wamr"
}:

let
  srcVer = {
    # We need the commit hash, since Bazel stamps the build with it.
    # However, the version string is more useful for end-users.
    # These are contained in a attrset of their own to make it obvious that
    # people should update both.
    version = "1.21.4";
    rev = "782ba5e5ab9476770378ec9f1901803e0d38ac41";
  };
in
buildBazelPackage rec {
  pname = "envoy";
  inherit (srcVer) version;
  bazel = bazel_4;
  src = fetchFromGitHub {
    owner = "envoyproxy";
    repo = "envoy";
    inherit (srcVer) rev;
    hash = "sha256-SthKDMQs5yNU0iouAPVsDeCPKcsBXmO9ebDwu58UQRs=";

    postFetch = ''
      chmod -R +w $out
      rm $out/.bazelversion
      echo ${srcVer.rev} > $out/SOURCE_VERSION
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

  patches = [
    # make linux/tcp.h relative. drop when upgrading to >1.21
    (fetchpatch {
      url = "https://github.com/envoyproxy/envoy/commit/68448aae7a78a3123097b6ea96016b270457e7b8.patch";
      sha256 = "123kv3x37p8fgfp29jhw5xg5js5q5ipibs8hsm7gzfd5bcllnpfh";
    })

    # fix issues with brotli and GCC 11.2.0+ (-Werror=vla-parameter)
    ./bump-brotli.patch

    # fix linux-aarch64 WAMR builds
    # (upstream WAMR only detects aarch64 on Darwin, not Linux)
    ./fix-aarch64-wamr.patch
  ];

  nativeBuildInputs = [
    cmake
    python3
    gn
    go
    jdk
    ninja
  ];

  buildInputs = [
    linuxHeaders
  ];

  fetchAttrs = {
    sha256 = {
      x86_64-linux = "sha256-/SA+WFHcMjk6iLwuEmuBIzy3pMhw7TThIEx292dv6IE=";
      aarch64-linux = "sha256-0XdeirdIP7+nKy8zZbr2uHN2RZ4ZFOJt9i/+Ow1s/W4=";
    }.${stdenv.system} or (throw "unsupported system ${stdenv.system}");
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

      # Remove Unix timestamps from go cache.
      rm -rf $bazelOut/external/bazel_gazelle_go_repository_cache/{gocache,pkg/mod/cache,pkg/sumdb}
    '';
  };
  buildAttrs = {
    dontUseCmakeConfigure = true;
    dontUseGnConfigure = true;
    dontUseNinjaInstall = true;
    preConfigure = ''
      sed -i 's,#!/usr/bin/env bash,#!${stdenv.shell},' $bazelOut/external/rules_foreign_cc/foreign_cc/private/framework/toolchains/linux_commands.bzl

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
    "--cxxopt=-Wno-error=type-limits"

    "--define=wasm=${wasmRuntime}"
  ];
  bazelFetchFlags = [
    "--define=wasm=${wasmRuntime}"
  ];

  passthru.tests = {
    envoy = nixosTests.envoy;
    # tested as a core component of Pomerium
    pomerium = nixosTests.pomerium;
  };

  meta = with lib; {
    homepage = "https://envoyproxy.io";
    description = "Cloud-native edge and service proxy";
    license = licenses.asl20;
    maintainers = with maintainers; [ lukegb ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
