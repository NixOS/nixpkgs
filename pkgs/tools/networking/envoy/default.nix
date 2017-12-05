{ stdenv, lib, fetchFromGitHub, pkgconfig, bazel, c-ares, backward-cpp
, libevent, gtest, gperftools, http-parser, lightstep-tracer-cpp
, nghttp2, protobuf3_2, tclap, rapidjson, spdlog, boringssl, buildEnv
}:

let
  protobuf_bzl =
    fetchFromGitHub {
      owner = "htuch";
      repo = "protobuf";
      rev = "d490587268931da78c942a6372ef57bb53db80da";
      sha256 = "100494s66xclw88bdnpb6d386vgw0gwz90sni37q7fqmi9w99z6v";
    };

  # Based on ci/prebuilt/BUILD
  #
  # The paths have been fixed up, and the static archives have been replaced
  # with dynamic libraries where presently possible.
  #
  # At the moment, this doesn't _need_ to be a map that we dynamically create a
  # BUILD file from (we could instead just include the contents directly);
  # however, this sets us up to be ready if we (or upstream) decide to split
  # things into multiple bazel repos, instead of one.
  ccTargets = {
    ares = {
      pkg = c-ares;
      srcs = ''["lib/libcares.so"]'';
      hdrs = ''glob(["include/ares*.h"])'';
      includes = ''["include"]'';
    };

    backward = {
      pkg = backward-cpp;
      hdrs = ''["include/backward.hpp"]'';
      includes = ''["include"]'';
    };

    crypto = {
      pkg = boringssl;
      srcs = ''["lib/libcrypto.a"]'';
      hdrs = ''glob(["include/openssl/**/*.h"])'';
      includes = ''["include"]'';
    };

    event = {
      pkg = libevent;
      srcs = ''["lib/libevent.so"]'';
      hdrs = ''glob(["include/event2/**/*.h"])'';
      includes = ''["include"]'';
    };

    event_pthreads = {
      pkg = libevent;
      srcs = ''["lib/libevent_pthreads.so"]'';
      deps = ''[":event"]'';
    };

    googletest = {
      pkg = gtest;
      srcs = ''[ "lib/libgmock.so", "lib/libgtest.so" ]'';
      hdrs = ''glob(["include/gmock/**/*.h", "include/gtest/**/*.h"])'';
      includes = ''["include"]'';
    };

    http_parser = {
      pkg = http-parser;
      srcs = ''["lib/libhttp_parser.so"]'';
      hdrs = ''glob(["include/http_parser.h"])'';
      includes = ''["include"]'';
    };

    lightstep = {
      pkg = lightstep-tracer-cpp;
      srcs = ''["lib/liblightstep_core_cxx11.a"]'';
      hdrs = ''glob([ "include/lightstep/**/*.h", "include/mapbox_variant/**/*.hpp" ]) + [ "include/collector.pb.h", "include/lightstep_carrier.pb.h" ]'';
      includes = ''["include"]'';
      deps = ''[":protobuf"]'';
    };

    nghttp2 = {
      pkg = nghttp2;
      srcs = ''["lib/libnghttp2.so"]'';
      hdrs = ''glob(["include/nghttp2/**/*.h"])'';
      includes = ''["include"]'';
    };

    protobuf = {
      pkg = protobuf3_2;
      srcs = ''glob(["lib/libproto*.so"])'';
      hdrs = ''glob(["include/google/protobuf/**/*.h"])'';
      includes = ''["include"]'';
    };

    rapidjson = {
      pkg = rapidjson;
      hdrs = ''glob(["include/rapidjson/**/*.h"])'';
      includes = ''["include"]'';
    };

    spdlog = {
      pkg = spdlog;
      name = "spdlog";
      hdrs = ''glob([ "include/spdlog/**/*.cc", "include/spdlog/**/*.h" ])'';
      includes = ''["include"]'';
    };

    ssl = {
      pkg = boringssl;
      srcs = ''["lib/libssl.a"]'';
      deps = ''[":crypto"]'';
    };

    tclap = {
      pkg = tclap;
      hdrs = ''glob(["include/tclap/**/*.h"])'';
      includes = ''["include"]'';
    };

    tcmalloc_and_profiler = {
      pkg = gperftools;
      srcs = ''["lib/libtcmalloc_and_profiler.so"]'';
      hdrs = ''glob(["include/gperftools/**/*.h"])'';
      strip_include_prefix = ''"include"'';
    };
  };

  # Generate the BUILD file.
  buildFile =
    let field = name: attrs:
      if attrs ? "${name}" then "    ${name} = ${attrs.${name}},\n" else "";
    in
    ''
    licenses(["notice"])  # Apache 2

    package(default_visibility = ["//visibility:public"])

    '' +
    lib.concatStringsSep "\n\n" (
      lib.mapAttrsToList (name: value:
          "cc_library(\n"
        + "    name = \"${name}\",\n"
        + field "srcs" value
        + field "hdrs" value
        + field "deps" value
        + field "includes" value
        + field "strip_include_prefix" value
        + ")"
      ) ccTargets
    ) + ''

    filegroup(
        name = "protoc",
        srcs = ["bin/protoc"],
    )
    '';

  workspaceFile = 
    ''
    workspace(name = "nix")

    load("//bazel:repositories.bzl", "envoy_dependencies")
    load("//bazel:cc_configure.bzl", "cc_configure")

    new_local_repository(
        name = "nix_envoy_deps",
        path = "${repoEnv}",
        build_file = "nix_envoy_deps.BUILD"
    )

    envoy_dependencies(
        path = "@nix_envoy_deps//",
        skip_protobuf_bzl = True,
    )

    new_local_repository(
        name = "protobuf_bzl",
        path = "${protobuf_bzl}",
        # We only want protobuf.bzl, so don't support building out of this repo.
        build_file_content = "",
    )

    cc_configure()
    '';

  # The tree we'll use for our new_local_repository in our generated WORKSPACE.
  repoEnv = buildEnv {
    name = "repo-env";
    paths = lib.concatMap (p:
      lib.unique [(lib.getBin p) (lib.getLib p) (lib.getDev p)]
    ) allDeps;
  };

  rpath = stdenv.lib.makeLibraryPath (allDeps ++ [ stdenv.cc.cc ]);

  allDeps = [
    c-ares
    backward-cpp
    libevent
    gtest
    gperftools
    http-parser
    lightstep-tracer-cpp
    nghttp2
    protobuf3_2
    tclap
    rapidjson
    spdlog
    boringssl
  ];

  # Envoy checks at runtime that the git sha is valid,
  # so we really can't avoid putting some sort of sha here.
  rev = "3afc7712a04907ffd25ed497626639febfe65735";

in

stdenv.mkDerivation rec {
  name = "envoy-${version}";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "lyft";
    repo = "envoy";
    rev = "v${version}";
    sha256 = "0j1c9lyvncyhiq3kyhx91ckcjd2h68x56js7xb6ni6bzxinv6zb6";
  };

  nativeBuildInputs = [
    pkgconfig bazel
  ];

  buildInputs = allDeps;

  patches = [ ./nixos.patch ];

  hardeningDisable = "all";
  dontPatchELF = true;
  dontStrip = true;

  # set up our workspace,
  # and prevent an error where bazel/get_workspace_status tries to determine the
  # version by invoking git.
  postUnpack = ''
    cat <<'EOF' > $sourceRoot/WORKSPACE
    ${workspaceFile}
    EOF

    cat <<'EOF' > $sourceRoot/nix_envoy_deps.BUILD
    ${buildFile}
    EOF

    cat <<'EOF' > $sourceRoot/bazel/get_workspace_status
    #!${stdenv.shell}
    echo "BUILD_SCM_REVISION ${rev}"
    echo "BUILD_SCM_STATUS Modified"
    EOF
  '';

  buildPhase = ''
    runHook preBuild

    mkdir .home
    export HOME=$PWD/.home

    BAZEL_OPTIONS="--package_path %workspace%:$PWD"
    BAZEL_BUILD_OPTIONS="\
      --strategy=Genrule=standalone \
      --spawn_strategy=standalone \
      --verbose_failures \
      $BAZEL_OPTIONS \
      --action_env=HOME \
      --action_env=PYTHONUSERBASE \
      --show_task_finish"

    bazel \
      --batch \
      build \
      -s --verbose_failures \
      --experimental_ui \
      $BAZEL_BUILD_OPTIONS \
      -c opt \
      //source/exe:envoy-static

    exe=bazel-bin/source/exe/envoy-static
    chmod +w $exe
    patchelf --set-rpath ${rpath} $exe

    runHook postBuild
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv $exe $out/bin/envoy
  '';

  meta = with lib; {
    description = "L7 proxy and communication bus designed for large modern service oriented architectures";
    homepage = "https://lyft.github.io/envoy/";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ];
  };
}
