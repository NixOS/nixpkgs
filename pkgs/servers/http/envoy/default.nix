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
    version = "1.30.2";
    rev = "d79f6e8d453ee260e9094093b8dd31af0056e67b";
    hash = "sha256-qbe9M4dH7NFDY5UF17urJ6WvnZNhvdMU4HAg0BaL+KA=";
  };

  # these need to be updated for any changes to fetchAttrs
  depsHash = {
    x86_64-linux = "sha256-/IpTRFBkif1HSycPrWxphKTnhL6wHgPAweyxoXZ1oVg=";
    aarch64-linux = "sha256-uA1CHKzdBht+WYxgwR2g5t7fRybhbo6Hgpzdr+H1vqY=";
  }.${stdenv.system} or (throw "unsupported system ${stdenv.system}");
in
buildBazelPackage {
  pname = "envoy";
  inherit (srcVer) version;
  bazel = bazel_6;
  src = fetchFromGitHub {
    owner = "envoyproxy";
    repo = "envoy";
    inherit (srcVer) hash rev;

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

    cp ${./dd_trace_cpp.patch} bazel/dd_trace_cpp.patch
  '';

  patches = [
    # use system Python, not bazel-fetched binary Python
    ./0001-nixpkgs-use-system-Python.patch

    # use system Go, not bazel-fetched binary Go
    ./0002-nixpkgs-use-system-Go.patch

    # use system C/C++ tools
    ./0003-nixpkgs-use-system-C-C-toolchains.patch

    # apply patch to dd-trace-cpp
    # remove once a version of dd-trace-cpp is released and adopted by envoy
    # that contains https://github.com/DataDog/dd-trace-cpp/commit/3a8e1e9a3cf4e87ef053e954a39dc7a967ac6965
    ./0004-nixpkgs-add-cstdint-in-dd-trace-cpp.patch
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
    sha256 = depsHash;
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

      # fix tcmalloc failure https://github.com/envoyproxy/envoy/issues/30838
      sed -i '/TCMALLOC_GCC_FLAGS = \[/a"-Wno-changes-meaning",' $bazelOut/external/com_github_google_tcmalloc/tcmalloc/copts.bzl
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

    # undefined reference to 'grpc_core::*Metadata*::*Memento*
    #
    # During linking of the final binary, we see undefined references to grpc_core related symbols.
    # The missing symbols would be instantiations of a template class from https://github.com/grpc/grpc/blob/v1.59.4/src/core/lib/transport/metadata_batch.h
    # "ParseMemento" and "MementoToValue" are only implemented for some types
    # and appear unused and unimplemented for the undefined cases reported by the linker.
    "--linkopt=-Wl,--unresolved-symbols=ignore-in-object-files"

    "--define=wasm=${wasmRuntime}"
  ] ++ (lib.optionals stdenv.isAarch64 [
    # external/com_github_google_tcmalloc/tcmalloc/internal/percpu_tcmalloc.h:611:9: error: expected ':' or '::' before '[' token
    #   611 |       : [end_ptr] "=&r"(end_ptr), [cpu_id] "=&r"(cpu_id),
    #       |         ^
    "--define=tcmalloc=disabled"
  ]);

  bazelFetchFlags = [
    "--define=wasm=${wasmRuntime}"

    # https://github.com/bazelbuild/rules_go/issues/3844
    "--repo_env=GOPROXY=https://proxy.golang.org,direct"
    "--repo_env=GOSUMDB=sum.golang.org"
  ];

  passthru.tests = {
    envoy = nixosTests.envoy;
    # tested as a core component of Pomerium
    pomerium = nixosTests.pomerium;
  };

  meta = with lib; {
    homepage = "https://envoyproxy.io";
    changelog = "https://github.com/envoyproxy/envoy/releases/tag/v${version}";
    description = "Cloud-native edge and service proxy";
    mainProgram = "envoy";
    license = licenses.asl20;
    maintainers = with maintainers; [ lukegb ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
