{
  cacert,
  fetchFromGitHub,
  fetchpatch,
  rustPlatform,
  fetchCrate,
  buildWasmBindgenCli,
  lib,
  tailwindcss_4,
  pkg-config,
  vips,
  libheif,
  nasm,
  yasm,
  jemalloc,
  zlib,
  ffmpeg-headless,
  lcms2,
  libwebp,
  libyuv,
  libde265,
  dav1d,
  libaom,
  zstd,
  coreutils,
  gawk,
  git,
  bash,
  nodejs_26,
  pnpm_11,
  pnpmConfigHook,
  beamMinimal28Packages,
  rustc,
  cargo,
  clang,
  lld,
  brotli,
  makeWrapper,
  cargoDeps,
  pnpmDeps,
  fluxerHashes,
}:
let
  nodejs = nodejs_26;
  pnpm = pnpm_11.override { nodejs-slim = nodejs; };
  beamPackages = beamMinimal28Packages;
  zstdStatic = zstd.override { enableStatic = true; };
  wasm-bindgen-cli = buildWasmBindgenCli rec {
    src = fetchCrate {
      pname = "wasm-bindgen-cli";
      version = "0.2.128";
      hash = "sha256-a7lcXJnnZkYReja+iUO7NqqrWyv3toxnUgQb8s4IS5s=";
    };

    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit src;
      inherit (src) pname version;
      hash = "sha256-R1Tas33Ursy8kqsxguAkG0ZhNed2n5uFTAhw1l2qlLY=";
    };
  };

  apiPostBuildHook = ''
    pnpm --filter fluxer_api run build
  '';
  apiPostInstallHook = ''
    mkdir -p $out/lib/fluxer-api-deps

    pnpm config set --location=project injectWorkspacePackages true
    pnpm deploy \
      --filter=fluxer_api \
      --prod \
      $out/lib/fluxer-api-deps

    mkdir -p $out/lib/fluxer-api
    cp -r fluxer_api/dist/* $out/lib/fluxer-api/

    cat >$out/bin/fluxer-api <<EOF
    export NODE_PATH="$out/lib/fluxer-api-deps/node_modules"
    ${lib.getExe nodejs} "$out/lib/fluxer-api/AppEntrypoint.js"
    EOF
    chmod +x $out/bin/fluxer-api

    cat >$out/bin/fluxer-api-worker <<EOF
    export NODE_PATH="$out/lib/fluxer-api-deps/node_modules"
    ${lib.getExe nodejs} "$out/lib/fluxer-api/WorkerEntrypoint.js"
    EOF
    chmod +x $out/bin/fluxer-api-worker
  '';
  appProxyPostPatchHook = ''
    patchShebangs --build tools/ci/run.sh
    patchShebangs --build fluxer_app_proxy/scripts/precompress_assets.sh
  '';
  appProxyPostBuildHook = ''
    (
      unset CARGO_TARGET_DIR
      cd fluxer_app
      pnpm build
    )

    bash fluxer_app_proxy/scripts/precompress_assets.sh fluxer_app/dist
  '';
  appProxyPostInstallHook = ''
    mkdir -p $out/share/fluxer_app_proxy
    cp -r fluxer_app/dist/* $out/share/fluxer_app_proxy

    wrapProgram $out/bin/fluxer_app_proxy \
      --set-default FLUXER_STATIC_DIR $out/share/fluxer_app_proxy
  '';
  mediaProxyPostInstallHook = ''
    wrapProgram $out/bin/fluxer-media-proxy \
      --suffix LD_PRELOAD : ${jemalloc}/lib/libjemalloc.so \
      --set-default MALLOC_CONF "background_thread:true,metadata_thp:auto,dirty_decay_ms:5000,muzzy_decay_ms:5000" \
      --set-default VIPS_CONCURRENCY 1 \
      --set-default VIPS_DISC_THRESHOLD 1g
  '';
  staticPostInstallHook = ''
    mkdir -p $out/share/fluxer-static

    cp -r fluxer_static/* $out/share/fluxer-static
  '';
in
rustPlatform.buildRustPackage (
  finalAttrs:
  let
    fluxer-gateway = beamPackages.rebar3Relx {
      pname = "fluxer-gateway";
      inherit (finalAttrs) src version;

      releaseType = "release";
      profile = "prod";

      env.REBAR_SKIP_PROJECT_PLUGINS = "1";

      nativeBuildInputs = [
        cargo
        rustc
        rustPlatform.cargoSetupHook
        makeWrapper
      ];

      buildInputs = [
        coreutils
        gawk
      ];

      checkouts =
        (beamPackages.fetchRebar3Deps {
          inherit (finalAttrs) version;
          name = "fluxer-gateway-deps-0";
          src = "${finalAttrs.src}/fluxer_gateway";
          sha256 = fluxerHashes.rebar;
        }).overrideAttrs
          (
            final: prev: {
              nativeBuildInputs = (prev.nativeBuildInputs or [ ]) ++ [
                git
                cacert
              ];
              postInstall = ''
                find $out -name .git -prune -execdir rm -r {} +
              '';
            }
          );

      cargoDeps = finalAttrs.cargoDeps;

      postPatch = ''
        cp fluxer_gateway/config/sys.config{.template,}

        patchShebangs --build tools/ci/run.sh
      '';

      preConfigure = ''
        cd fluxer_gateway
      '';

      postConfigure =
        let
          pkg = "eqwalizer_support";
        in
        ''
          mv _checkouts/${pkg}/${pkg} intermediate-dir
          rm -r _checkouts/${pkg}
          mv intermediate-dir _checkouts/${pkg}

          substituteInPlace _checkouts/ezstd/Makefile \
            --replace-fail '@./build_deps.sh' '@${lib.getExe bash} build_deps.sh'

          # Prevent ezstd from fetching and building its own zstd
          mkdir -p _checkouts/ezstd/_build/deps/zstd/lib
          cp ${zstd.dev}/include/*.h _checkouts/ezstd/_build/deps/zstd/lib
          cp ${zstdStatic.out}/lib/libzstd.a _checkouts/ezstd/_build/deps/zstd/lib
        '';

      postFixup = ''
        wrapProgram $out/bin/fluxer_gateway \
          --set-default FLUXER_ERLANG_NODE_NAME fluxer-gateway@127.0.0.1 \
          --run 'export RELX_OUT_FILE_PATH="''${RELX_OUT_FILE_PATH:-$(mktemp -d)}"' \
          --prefix PATH : "${
            lib.makeBinPath [
              coreutils
              gawk
            ]
          }"

        install --mode=0755 scripts/docker_entrypoint.sh $out/bin/fluxer_gateway-entrypoint
        substituteInPlace $out/bin/fluxer_gateway-entrypoint \
          --replace-fail "#!/usr/bin/env sh" "#!${lib.getExe bash}" \
          --replace-fail "/opt/fluxer_gateway/bin/fluxer_gateway" "$out/bin/fluxer_gateway"
      '';
    };
  in
  {
    pname = "fluxer-server";
    inherit (fluxerHashes) version;

    src = fetchFromGitHub {
      owner = "fluxerapp";
      repo = "fluxer";
      inherit (fluxerHashes) rev hash;
    };

    env.npm_config_nodedir = nodejs;
    env.BUNDLE_LOCAL_ASSETS = true;

    inherit cargoDeps pnpmDeps;

    nativeBuildInputs = [
      nasm
      yasm
      pkg-config
      makeWrapper
      tailwindcss_4
      nodejs
      pnpm
      pnpmConfigHook
      cargo
      clang.cc
      lld
      brotli
      wasm-bindgen-cli
    ];

    nativeCheckInputs = [
      cacert
    ];

    buildInputs = [
      zlib
      vips
      libheif
      ffmpeg-headless
      lcms2
      libwebp
      libyuv
      libde265
      dav1d
      libaom
      jemalloc
    ];

    buildFeatures = [
      "scylla"
    ];

    patches = [
      (fetchpatch {
        url = "https://github.com/strangeglyph/fluxer/commit/e3d482c1fdc2.patch";
        hash = "sha256-gegp288cAFpa5fpeRFIaaecgn5wRv9neoT9koYqu/Ak=";
      })
    ];

    postPatch = ''
      ${appProxyPostPatchHook}
    '';

    postBuild = ''
      ${apiPostBuildHook}
      ${appProxyPostBuildHook}
    '';

    postInstall = ''
      ${apiPostInstallHook}
      ${appProxyPostInstallHook}
      ${mediaProxyPostInstallHook}
      ${staticPostInstallHook}

      cp ${fluxer-gateway}/bin/* $out/bin/
    '';

    meta = {
      description = "Rust packages for Fluxer, a free and open source instant messaging and VoIP chat app";
      license = with lib.licenses; [
        agpl3Plus # fluxer
        cc-by-40 # fluxer_app/src/media/images/i-like-food.svg
        mit # fluxer_app/src/media/images/neko.png, fluxer_app/src/features/accessibility/components/NekoSprite.tsx
        asl20 # fluxer_app/src/features/ui/components/icons/InboxIcon.tsx
      ];
      homepage = "https://github.com/fluxerapp/fluxer";
      maintainers = [ lib.maintainers.strangeglyph ];

    };
  }
)
