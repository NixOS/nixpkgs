{
  lib,
  stdenv,
  chromium,
  nodejs,
  fetchYarnDeps,
  fetchNpmDeps,
  fetchpatch,
  fixup-yarn-lock,
  npmHooks,
  yarn,
  libnotify,
  unzip,
  pkgsBuildHost,
  pipewire,
  libsecret,
  libpulseaudio,
  speechd-minimal,
  info,
  gclient2nix,
}:

let
  gclientDeps = gclient2nix.importGclientDeps info.deps;
in

((chromium.override { upstream-info = info.chromium; }).mkDerivation (base: {
  packageName = "electron";
  inherit (info) version;
  buildTargets = [
    "electron:copy_node_headers"
    "electron:electron_dist_zip"
  ];

  outputs = [
    "out"
    "headers"
  ];

  # don't automatically move the include directory from $headers back into $out
  moveToDev = false;

  nativeBuildInputs = base.nativeBuildInputs ++ [
    nodejs
    yarn
    fixup-yarn-lock
    unzip
    npmHooks.npmConfigHook
    gclient2nix.gclientUnpackHook
  ];
  buildInputs = base.buildInputs ++ [ libnotify ];

  electronOfflineCache = fetchYarnDeps {
    yarnLock = gclientDeps."src/electron".path + "/yarn.lock";
    sha256 = info.electron_yarn_hash;
  };
  npmDeps = fetchNpmDeps rec {
    src = gclientDeps."src".path;
    # Assume that the fetcher always unpack the source,
    # based on update.py
    sourceRoot = "${src.name}/third_party/node";
    hash = info.chromium_npm_hash;
  };
  inherit gclientDeps;
  unpackPhase = null; # prevent chromium's unpackPhase from being used
  sourceRoot = "src";

  env = base.env // {
    # Hydra can fail to build electron due to clang spamming deprecation
    # warnings mid-build, causing the build log to grow beyond the limit
    # of 64mb and then getting killed by Hydra.
    # For some reason, the log size limit appears to only be enforced on
    # aarch64-linux. x86_64-linux happily succeeds to build with ~180mb. To
    # unbreak the build on h.n.o, we simply disable those warnings for now.
    # https://hydra.nixos.org/build/283952243
    NIX_CFLAGS_COMPILE = base.env.NIX_CFLAGS_COMPILE + " -Wno-deprecated";
    # Needed for header generation in electron 35 and above
    ELECTRON_OUT_DIR = "Release";
  };

  src = null;

  patches =
    base.patches
    ++ lib.optionals (lib.versionOlder info.version "38") [
      # Fix build with Rust 1.89.0
      # https://chromium-review.googlesource.com/c/chromium/src/+/6624733
      (fetchpatch {
        name = "Define-rust-no-alloc-shim-is-unstable-v2.patch";
        url = "https://github.com/chromium/chromium/commit/6aae0e2353c857d98980ff677bf304288d7c58de.patch";
        hash = "sha256-Dd38c/0hiH+PbGPJhhEFuW6kUR45A36XZqOVExoxlhM=";
      })
      # Fix build with LLVM 21+
      # https://chromium-review.googlesource.com/c/chromium/src/+/6633292
      (fetchpatch {
        name = "Dont-return-an-enum-from-EnumSizeTraits-Count.patch";
        url = "https://github.com/chromium/chromium/commit/b0ff8c3b258a8816c05bdebf472dbba719d3c491.patch";
        hash = "sha256-YIWcsCj5w0jUd7D67hsuk0ljTA/IbHwA6db3eK4ggUY=";
      })
    ]
    ++ lib.optionals (lib.versionOlder info.version "39") [
      # Fix build with Rust 1.90.0
      # https://chromium-review.googlesource.com/c/chromium/src/+/6875644
      (fetchpatch {
        name = "Define-rust-alloc-error-handler-should-panic-v2.patch";
        url = "https://github.com/chromium/chromium/commit/23d818d3c7fba4658248f17fd7b8993199242aa9.patch";
        hash = "sha256-JVv36PgU/rr34jrhgCyf4Pp8o5j2T8fD1xBVH1avT48=";
      })
      # Fix build with Rust 1.91.0
      # https://chromium-review.googlesource.com/c/chromium/src/+/6949745
      (fetchpatch {
        name = "Remove-unicode_width-from-rust-dependencies.patch";
        url = "https://github.com/chromium/chromium/commit/0420449584e2afb7473393f536379efe194ba23c.patch";
        hash = "sha256-2x1QoKkZEBfJw0hBjaErN/E47WrVfZvDngAXSIDzJs4=";
      })
      (fetchpatch {
        name = "CrabbyAvif-Switch-from-no_sanitize-cfi-to-sanitize-cfi-off-1.patch";
        url = "https://github.com/webmproject/CrabbyAvif/commit/4c70b98d1ebc8a210f2919be7ccabbcf23061cb5.patch";
        extraPrefix = "third_party/crabbyavif/src/";
        stripLen = 1;
        hash = "sha256-E8/PmL+8+ZSoDO6L0/YOygIsliCDmcaBptXsi2L6ETQ=";
      })
      # backport of https://github.com/webmproject/CrabbyAvif/commit/3ba05863e84fd3acb4f4af2b4545221b317a2e55
      ./CrabbyAvif-Switch-from-no_sanitize-cfi-to-sanitize-cfi-off-2.patch
      # https://chromium-review.googlesource.com/c/chromium/src/+/6879484
      (fetchpatch {
        name = "crabbyavif-BUILD-gn-Temporarily-remove-disable_cfi-feature.patch";
        url = "https://github.com/chromium/chromium/commit/e46275404d8f8a65ed84b3e583e9b78e4298acc7.patch";
        hash = "sha256-2Dths53ervzCPKFbAVxeBHxtPHckxYhesJhaYZbxGSA=";
      })
      # https://chromium-review.googlesource.com/c/chromium/src/+/6960510
      (fetchpatch {
        name = "crabbyavif-BUILD-gn-Enable-disable_cfi-feature.patch";
        url = "https://github.com/chromium/chromium/commit/9415f40bc6f853547f791e633be638c71368ce56.patch";
        hash = "sha256-+M4gI77SoQ4dYIe/iGFgIwF1fS/6KQ8s16vj8ht/rik=";
      })
    ];

  npmRoot = "third_party/node";

  postPatch = ''
    mkdir -p third_party/jdk/current/bin

    echo 'build_with_chromium = true' >> build/config/gclient_args.gni
    echo 'checkout_google_benchmark = false' >> build/config/gclient_args.gni
    echo 'checkout_android = false' >> build/config/gclient_args.gni
    echo 'checkout_android_prebuilts_build_tools = false' >> build/config/gclient_args.gni
    echo 'checkout_android_native_support = false' >> build/config/gclient_args.gni
    echo 'checkout_ios_webkit = false' >> build/config/gclient_args.gni
    echo 'checkout_nacl = false' >> build/config/gclient_args.gni
    echo 'checkout_openxr = false' >> build/config/gclient_args.gni
    echo 'checkout_rts_model = false' >> build/config/gclient_args.gni
    echo 'checkout_src_internal = false' >> build/config/gclient_args.gni
    echo 'cros_boards = ""' >> build/config/gclient_args.gni
    echo 'cros_boards_with_qemu_images = ""' >> build/config/gclient_args.gni
    echo 'generate_location_tags = true' >> build/config/gclient_args.gni

    echo 'LASTCHANGE=${info.deps."src".args.tag}-refs/heads/master@{#0}' > build/util/LASTCHANGE
    echo "$SOURCE_DATE_EPOCH" > build/util/LASTCHANGE.committime

    cat << EOF > gpu/config/gpu_lists_version.h
    /* Generated by lastchange.py, do not edit.*/
    #ifndef GPU_CONFIG_GPU_LISTS_VERSION_H_
    #define GPU_CONFIG_GPU_LISTS_VERSION_H_
    #define GPU_LISTS_VERSION "${info.deps."src".args.tag}"
    #endif  // GPU_CONFIG_GPU_LISTS_VERSION_H_
    EOF

    cat << EOF > skia/ext/skia_commit_hash.h
    /* Generated by lastchange.py, do not edit.*/
    #ifndef SKIA_EXT_SKIA_COMMIT_HASH_H_
    #define SKIA_EXT_SKIA_COMMIT_HASH_H_
    #define SKIA_COMMIT_HASH "${info.deps."src/third_party/skia".args.rev}-"
    #endif  // SKIA_EXT_SKIA_COMMIT_HASH_H_
    EOF

    echo -n '${info.deps."src/third_party/dawn".args.rev}' > gpu/webgpu/DAWN_VERSION
  ''
  + lib.optionalString (lib.versionAtLeast info.version "39") ''
    cat << EOF > gpu/webgpu/dawn_commit_hash.h
    /* Generated by lastchange.py, do not edit.*/
    #ifndef GPU_WEBGPU_DAWN_COMMIT_HASH_H_
    #define GPU_WEBGPU_DAWN_COMMIT_HASH_H_
    #define DAWN_COMMIT_HASH "${info.deps."src/third_party/dawn".args.rev}"
    #endif  // GPU_WEBGPU_DAWN_COMMIT_HASH_H_
    EOF
  ''
  + ''

    (
      cd electron
      export HOME=$TMPDIR/fake_home
      yarn config --offline set yarn-offline-mirror $electronOfflineCache
      fixup-yarn-lock yarn.lock
      yarn install --offline --frozen-lockfile --ignore-scripts --no-progress --non-interactive
    )

    (
      cd ..
      PATH=$PATH:${
        lib.makeBinPath (
          with pkgsBuildHost;
          [
            jq
            git
          ]
        )
      }
      config=src/electron/patches/config.json
      for entry in $(cat $config | jq -c ".[]")
      do
        patch_dir=$(echo $entry | jq -r ".patch_dir")
        repo=$(echo $entry | jq -r ".repo")
        for patch in $(cat $patch_dir/.patches)
        do
          echo applying in $repo: $patch
          git apply -p1 --directory=$repo --exclude='src/third_party/blink/web_tests/*' --exclude='src/content/test/data/*' $patch_dir/$patch
        done
      done
    )
    echo 'checkout_glic_e2e_tests = false' >> build/config/gclient_args.gni
    echo 'checkout_mutter = false' >> build/config/gclient_args.gni
  ''
  + lib.optionalString (lib.versionAtLeast info.version "38") ''
    echo 'checkout_clusterfuzz_data = false' >> build/config/gclient_args.gni
  ''
  + base.postPatch;

  preConfigure = ''
    (
      cd third_party/node
      grep patch update_npm_deps | sh
    )
  ''
  + (base.preConfigure or "");

  gnFlags = rec {
    # build/args/release.gn
    is_component_build = false;
    is_official_build = true;
    rtc_use_h264 = proprietary_codecs;
    is_component_ffmpeg = true;

    # build/args/all.gn
    is_electron_build = true;
    root_extra_deps = [ "//electron" ];
    node_module_version = lib.toInt info.modules;
    v8_promise_internal_field_count = 1;
    v8_embedder_string = "-electron.0";
    v8_enable_snapshot_native_code_counters = false;
    v8_enable_javascript_promise_hooks = true;
    enable_cdm_host_verification = false;
    proprietary_codecs = true;
    ffmpeg_branding = "Chrome";
    enable_printing = true;
    angle_enable_vulkan_validation_layers = false;
    dawn_enable_vulkan_validation_layers = false;
    enable_pseudolocales = false;
    allow_runtime_configurable_key_storage = true;
    enable_cet_shadow_stack = false;
    is_cfi = false;
    v8_builtins_profiling_log_file = "";
    enable_dangling_raw_ptr_checks = false;
    dawn_use_built_dxc = false;
    v8_enable_private_mapping_fork_optimization = true;
    v8_expose_public_symbols = true;
    enable_dangling_raw_ptr_feature_flag = false;
    clang_unsafe_buffers_paths = "";
    enterprise_cloud_content_analysis = false;
  }
  // lib.optionalAttrs (lib.versionAtLeast info.version "39") {
    enable_linux_installer = false;
    enable_pdf_save_to_drive = false;
  }
  // {

    # other
    enable_widevine = false;
    override_electron_version = info.version;
  }
  // lib.optionalAttrs (lib.versionOlder info.version "38") {
    content_enable_legacy_ipc = true;
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $libExecPath
    unzip -d $libExecPath out/Release/dist.zip

    mkdir -p $headers
    cp -r out/Release/gen/node_headers/* $headers/

    runHook postInstall
  '';

  postFixup =
    let
      libPath = lib.makeLibraryPath [
        libnotify
        pipewire
        stdenv.cc.cc
        libsecret
        libpulseaudio
        speechd-minimal
      ];
    in
    base.postFixup
    + ''
      patchelf \
        --add-rpath "${libPath}" \
        $out/libexec/electron/electron
    '';

  requiredSystemFeatures = [ "big-parallel" ];

  passthru = {
    inherit info;
  };

  meta = with lib; {
    description = "Cross platform desktop application shell";
    homepage = "https://github.com/electron/electron";
    platforms = lib.platforms.linux;
    license = licenses.mit;
    teams = [ teams.electron ];
    mainProgram = "electron";
    hydraPlatforms =
      lib.optionals (!(hasInfix "alpha" info.version) && !(hasInfix "beta" info.version))
        [
          "aarch64-linux"
          "x86_64-linux"
        ];
    timeout = 172800; # 48 hours (increased from the Hydra default of 10h)
  };
})).overrideAttrs
  (
    finalAttrs: prevAttrs: {
      # this was the only way I could get the package to properly reference itself
      passthru = prevAttrs.passthru // {
        dist = finalAttrs.finalPackage + "/libexec/electron";
      };
    }
  )
