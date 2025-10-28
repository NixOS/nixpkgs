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

  env =
    base.env
    // {
      # Hydra can fail to build electron due to clang spamming deprecation
      # warnings mid-build, causing the build log to grow beyond the limit
      # of 64mb and then getting killed by Hydra.
      # For some reason, the log size limit appears to only be enforced on
      # aarch64-linux. x86_64-linux happily succeeds to build with ~180mb. To
      # unbreak the build on h.n.o, we simply disable those warnings for now.
      # https://hydra.nixos.org/build/283952243
      NIX_CFLAGS_COMPILE = base.env.NIX_CFLAGS_COMPILE + " -Wno-deprecated";
    }
    // lib.optionalAttrs (lib.versionAtLeast info.version "35") {
      # Needed for header generation in electron 35 and above
      ELECTRON_OUT_DIR = "Release";
    };

  src = null;

  patches =
    base.patches
    # Fix building with Rust 1.87+
    # https://issues.chromium.org/issues/407024458
    ++ lib.optionals (lib.versionOlder info.version "37") [
      # https://chromium-review.googlesource.com/c/chromium/src/+/6432410
      # Not using fetchpatch here because it ignores file renames: https://github.com/nixos/nixpkgs/issues/32084
      ./Reland-Use-global_allocator-to-provide-Rust-allocator-implementation.patch

      # https://chromium-review.googlesource.com/c/chromium/src/+/6434355
      (fetchpatch {
        name = "Call-Rust-default-allocator-directly-from-Rust.patch";
        url = "https://github.com/chromium/chromium/commit/73eef8797a8138f5c26f52a1372644b20613f5ee.patch";
        hash = "sha256-IcSjPv21xT+l9BwJuzeW2AfwBdKI0dQb3nskk6yeKHU=";
      })

      # https://chromium-review.googlesource.com/c/chromium/src/+/6439711
      (fetchpatch {
        name = "Roll-rust.patch";
        url = "https://github.com/chromium/chromium/commit/a6c30520486be844735dc646cd5b9b434afa0c6b.patch";
        includes = [ "build/rust/allocator/*" ];
        hash = "sha256-MFdR75oSAdFW6telEZt/s0qdUvq/BiYFEHW0vk+RgDk=";
      })

      # https://chromium-review.googlesource.com/c/chromium/src/+/6456604
      (fetchpatch {
        name = "Drop-remap_alloc-dep.patch";
        url = "https://github.com/chromium/chromium/commit/87d5ad2f621e0d5c81849dde24f3a5347efcb167.patch";
        hash = "sha256-bEoR6jxEyw6Fzm4Zv4US54Cxa0li/0UTZTU2WUf0Rgo=";
      })

      # https://chromium-review.googlesource.com/c/chromium/src/+/6454872
      (fetchpatch {
        name = "rust-Clean-up-build-rust-allocator-after-a-Rust-tool.patch";
        url = "https://github.com/chromium/chromium/commit/5c74fcf6fd14491f33dd820022a9ca045f492f68.patch";
        hash = "sha256-vcD0Zfo4Io/FVpupWOdgurFEqwFCv+oDOtSmHbm+ons=";
      })
    ]
    # Fix building with gperf 3.2+
    # https://issues.chromium.org/issues/40209959
    ++ lib.optionals (lib.versionOlder info.version "37") [
      # https://chromium-review.googlesource.com/c/chromium/src/+/6445471
      (fetchpatch {
        name = "Dont-apply-FALLTHROUGH-edit-to-gperf-3-2-output.patch";
        url = "https://github.com/chromium/chromium/commit/f8f21fb4aa01f75acbb12abf5ea8c263c6817141.patch";
        hash = "sha256-z/aQ1oQjFZnkUeRnrD6P/WDZiYAI1ncGhOUM+HmjMZA=";
      })
    ]
    # Fix build with Rust 1.89.0
    ++ lib.optionals (lib.versionOlder info.version "38") [
      # https://chromium-review.googlesource.com/c/chromium/src/+/6624733
      (fetchpatch {
        name = "Define-rust-no-alloc-shim-is-unstable-v2.patch";
        url = "https://github.com/chromium/chromium/commit/6aae0e2353c857d98980ff677bf304288d7c58de.patch";
        hash = "sha256-Dd38c/0hiH+PbGPJhhEFuW6kUR45A36XZqOVExoxlhM=";
      })
    ]
    ++ lib.optionals (lib.versionOlder info.version "38") [
      # Fix build with LLVM 21+
      # https://chromium-review.googlesource.com/c/chromium/src/+/6633292
      (fetchpatch {
        name = "Dont-return-an-enum-from-EnumSizeTraits-Count.patch";
        url = "https://github.com/chromium/chromium/commit/b0ff8c3b258a8816c05bdebf472dbba719d3c491.patch";
        hash = "sha256-YIWcsCj5w0jUd7D67hsuk0ljTA/IbHwA6db3eK4ggUY=";
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
  ''
  + lib.optionalString (lib.versionAtLeast info.version "36") ''
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
