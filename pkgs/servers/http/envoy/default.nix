{ lib
, bazel_6
, bazel-gazelle
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
    version = "1.27.1";
    rev = "6b9db09c69965d5bfb37bdd29693f8b7f9e9e9ec";
  };
in
buildBazelPackage rec {
  pname = "envoy";
  inherit (srcVer) version;
  bazel = bazel_6;
  src = fetchFromGitHub {
    owner = "envoyproxy";
    repo = "envoy";
    inherit (srcVer) rev;
    hash = "sha256-eZ3UCVqQbtK2GbawUVef5+BMSQbqe+owtwH+b887mQE=";

    postFetch = ''
      chmod -R +w $out
      rm $out/.bazelversion
      echo ${srcVer.rev} > $out/SOURCE_VERSION
    '';
  };

  postPatch = ''
    sed -i 's,#!/usr/bin/env python3,#!${python3}/bin/python,' bazel/foreign_cc/luajit.patch
    sed -i '/javabase=/d' .bazelrc
    sed -i '/"-Werror"/d' bazel/envoy_internal.bzl

    cp ${./protobuf.patch} bazel/protobuf.patch
  '';

  patches = [
    # use system Python, not bazel-fetched binary Python
    ./0001-nixpkgs-use-system-Python.patch

    # use system Go, not bazel-fetched binary Go
    ./0002-nixpkgs-use-system-Go.patch

    # use system C/C++ tools
    ./0003-nixpkgs-use-system-C-C-toolchains.patch
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

  # external/com_github_grpc_grpc/src/core/ext/transport/binder/transport/binder_transport.cc:756:29: error: format not a string literal and no format arguments [-Werror=format-security]
  hardeningDisable = [ "format" ];

  fetchAttrs = {
    sha256 = {
      x86_64-linux = "sha256-OQ4vg4S3DpM+Zo+igncx3AXJnL8FkJbwh7KnBhbnCUM=";
      aarch64-linux = "sha256-/X8i1vzQ4QvFxi1+5rc1/CGHmRhhu5F3X5A3PgbW+Mc=";
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
        $bazelOut/external/local_config_sh/BUILD \
        $bazelOut/external/*_pip3/BUILD.bazel

      rm -r $bazelOut/external/go_sdk
      rm -r $bazelOut/external/local_jdk
      rm -r $bazelOut/external/bazel_gazelle_go_repository_tools/bin

      # Remove compiled python
      find $bazelOut -name '*.pyc' -delete

      # Remove Unix timestamps from go cache.
      rm -rf $bazelOut/external/bazel_gazelle_go_repository_cache/{gocache,pkg/mod/cache,pkg/sumdb}
    '';
  };
  buildAttrs = {
    dontUseCmakeConfigure = true;
    dontUseGnConfigure = true;
    dontUseNinjaInstall = true;
    preConfigure = ''
      # Make executables work, for the most part.
      find $bazelOut/external -type f -executable | while read execbin; do
        file "$execbin" | grep -q ': ELF .*, dynamically linked,' || continue
        patchelf \
          --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) \
          "$execbin"
      done

      ln -s ${bazel-gazelle}/bin $bazelOut/external/bazel_gazelle_go_repository_tools/bin

      sed -i 's,#!/usr/bin/env bash,#!${stdenv.shell},' $bazelOut/external/rules_foreign_cc/foreign_cc/private/framework/toolchains/linux_commands.bzl

      # Add paths to Nix store back.
      sed -i \
        -e 's,__NIXPYTHON__,${python3},' \
        -e 's,__NIXSHELL__,${stdenv.shellPackage},' \
        $bazelOut/external/com_github_luajit_luajit/build.py \
        $bazelOut/external/local_config_sh/BUILD \
        $bazelOut/external/*_pip3/BUILD.bazel
    '';
    installPhase = ''
      install -Dm0755 bazel-bin/source/exe/envoy-static $out/bin/envoy
    '';
  };

  removeRulesCC = false;
  removeLocalConfigCc = true;
  removeLocal = false;
  bazelTargets = [ "//source/exe:envoy-static" ];
  bazelBuildFlags = [
    "-c opt"
    "--spawn_strategy=standalone"
    "--noexperimental_strict_action_env"
    "--cxxopt=-Wno-error"
    "--linkopt=-Wl,-z,noexecstack"

    # Force use of system Java.
    "--extra_toolchains=@local_jdk//:all"
    "--java_runtime_version=local_jdk"
    "--tool_java_runtime_version=local_jdk"

    "--define=wasm=${wasmRuntime}"
  ] ++ (lib.optionals stdenv.isAarch64 [
    # external/com_github_google_tcmalloc/tcmalloc/internal/percpu_tcmalloc.h:611:9: error: expected ':' or '::' before '[' token
    #   611 |       : [end_ptr] "=&r"(end_ptr), [cpu_id] "=&r"(cpu_id),
    #       |         ^
    "--define=tcmalloc=disabled"
  ]);
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
