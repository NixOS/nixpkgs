{ lib
, buildBazelPackage
, fetchFromGitHub
, stdenv
, cmake
, go
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
    version = "1.16.2";
    commit = "e98e41a8e168af7acae8079fc0cd68155f699aa3";
  };
in
buildBazelPackage rec {
  pname = "envoy";
  version = srcVer.version;
  src = fetchFromGitHub {
    owner = "envoyproxy";
    repo = "envoy";
    rev = srcVer.commit;
    hash = "sha256-aWVMRKFCZzf9/96NRPCP4jiW38DJhXyi0gEqW7uIpnQ=";

    extraPostFetch = ''
      chmod -R +w $out
      rm $out/.bazelversion
      echo ${srcVer.commit} > $out/SOURCE_VERSION
      sed -i 's/GO_VERSION = ".*"/GO_VERSION = "host"/g' $out/bazel/dependency_imports.bzl
    '';
  };

  patches = [
    # Quiche needs to be updated to compile under newer GCC.
    # This is a manual backport of https://github.com/envoyproxy/envoy/pull/13949.
    ./0001-quiche-update-QUICHE-tar-13949.patch

    # upb needs to be updated to compile under newer GCC.
    # This is a manual backport of https://github.com/protocolbuffers/upb/commit/9bd23dab4240b015321a53c45b3c9e4847fbf020.
    ./0002-Add-upb-patch-to-make-it-compile-under-GCC10.patch
  ];
  postPatch = ''
    sed -i 's,#!/usr/bin/env python3,#!${python3}/bin/python,' bazel/foreign_cc/luajit.patch
  '';

  nativeBuildInputs = [
    cmake
    python3
    go
    ninja
  ];

  fetchAttrs = {
    sha256 = "0q72c2zrl5vc8afkhkwyalb2h0mxn3133d4b9z4gag0p95wbwgc0";
    dontUseCmakeConfigure = true;
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
    '';
  };
  buildAttrs = {
    dontUseCmakeConfigure = true;
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

  fetchConfigured = true;
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
