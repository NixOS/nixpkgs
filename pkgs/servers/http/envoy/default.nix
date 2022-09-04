{ lib
, bazel_5
, buildBazelPackage
, fetchFromGitHub
, stdenv
, cmake
, gn
, go
, jdk
, ninja
, patchelf
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
    version = "1.23.1";
    rev = "edd69583372955fdfa0b8ca3820dd7312c094e46";
  };
in
buildBazelPackage rec {
  pname = "envoy";
  inherit (srcVer) version;
  bazel = bazel_5;
  src = fetchFromGitHub {
    owner = "envoyproxy";
    repo = "envoy";
    inherit (srcVer) rev;
    sha256 = "sha256:157dbmp479xv5507n48yibvlgi2ac0l3sl9rzm28cm9lhzwva3k0";

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

    # Use system Python.
    sed -i -e '/python_interpreter_target =/d' -e '/@python3_10/d' bazel/python_dependencies.bzl
  '';

  patches = [
    # fix issues with brotli and GCC 11.2.0+ (-Werror=vla-parameter)
    ./bump-brotli.patch

    # fix linux-aarch64 WAMR builds
    # (upstream WAMR only detects aarch64 on Darwin, not Linux)
    ./fix-aarch64-wamr.patch

    # use system Python, not bazel-fetched binary Python
    ./use-system-python.patch
  ];

  nativeBuildInputs = [
    cmake
    python3
    gn
    go
    jdk
    ninja
    patchelf
  ];

  buildInputs = [
    linuxHeaders
  ];

  fetchAttrs = {
    sha256 = {
      x86_64-linux = "0y3gpvx148bnn6kljdvkg99m681vw39l0avrhvncbf62hvpifqkw";
      aarch64-linux = "0lln5mdlskahz5hb4w268ys2ksy3051drrwlhracmk4i7rpm7fq3";
    }.${stdenv.system} or (throw "unsupported system ${stdenv.system}");
    dontUseCmakeConfigure = true;
    dontUseGnConfigure = true;
    preInstall = ''
      # Strip out the path to the build location (by deleting the comment line).
      find $bazelOut/external -name requirements.bzl | while read requirements; do
        sed -i '/# Generated from /d' "$requirements"
      done
      find $bazelOut/external -type f -executable | while read execbin; do
        file "$execbin" | grep -q ': ELF .*, dynamically linked,' || continue
        patchelf \
          --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) \
          "$execbin"
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
    "--cxxopt=-Wno-error=range-loop-construct"

    # Force use of system Java.
    "--extra_toolchains=@local_jdk//:all"
    "--java_runtime_version=local_jdk"
    "--tool_java_runtime_version=local_jdk"

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
