{
  nodejs_26,
  nodejs-slim_26,
  pnpm_11,
  cacert,
  cargo,
  rustc,
  clang,
  lld,
  brotli,
  buildWasmBindgenCli,
  makeBinaryWrapper,
  pnpmConfigHook,
  pkg-config,
  fetchPnpmDeps,
  fetchCrate,
  fetchFromGitHub,
  rustPlatform,
  runCommand,
  lib,
}:
let
  nodejs = nodejs_26;
  pnpm = pnpm_11.override { nodejs-slim = nodejs-slim_26; };
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

  copyVendorDeps =
    deps:
    ''cp -r --no-clobber --no-preserve=mode "${deps}/source-registry-0/." "$out/source-registry-0/"'';
  mergeVendorDeps =
    root-dep: extra-dep-list:
    runCommand "merge-vendor-deps" { } ''
      mkdir -p $out

      cp -r --no-preserve=mode "${root-dep}/." "$out/"

      ${lib.join "\n" (lib.map copyVendorDeps extra-dep-list)}
    '';

  versioning = lib.importJSON ./versioning.json;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fluxer-app-proxy";
  inherit (versioning) version;

  src = fetchFromGitHub {
    owner = "fluxerapp";
    repo = "fluxer";
    inherit (versioning) rev hash;
  };

  env.npm_config_nodedir = nodejs;
  env.BUNDLE_LOCAL_ASSETS = true;

  nativeBuildInputs = [
    makeBinaryWrapper
    nodejs
    pnpm
    pnpmConfigHook
    pkg-config
    cargo
    rustc
    clang.cc
    lld
    brotli
    rustPlatform.cargoSetupHook
    wasm-bindgen-cli
  ];

  nativeCheckInputs = [
    cacert
  ];

  cargoRootDep = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = versioning.cargoHash;
  };
  cargoExtraDeps = [
    (rustPlatform.fetchCargoVendor {
      inherit (finalAttrs) src;
      hash = versioning.libfluxcoreHash;
      sourceRoot = "${finalAttrs.src.name}/fluxer_app/rust/libfluxcore";
    })
    (rustPlatform.fetchCargoVendor {
      inherit (finalAttrs) src;
      hash = versioning.libfluxwebpHash;
      sourceRoot = "${finalAttrs.src.name}/fluxer_app/rust/libfluxwebp";
    })
  ];
  cargoDeps = mergeVendorDeps finalAttrs.cargoRootDep finalAttrs.cargoExtraDeps;

  buildAndTestSubdir = "fluxer_app_proxy";

  pnpmWorkspaces = [ "fluxer_app..." ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    inherit pnpm;
    fetcherVersion = 4;
    hash = versioning.appproxyPnpmHash;
  };

  postPatch = ''
    patchShebangs --build tools/ci/run.sh
    patchShebangs --build fluxer_app_proxy/scripts/precompress_assets.sh
  '';

  postBuild = ''
    (
      unset CARGO_TARGET_DIR
      cd fluxer_app
      pnpm build
    )

    bash fluxer_app_proxy/scripts/precompress_assets.sh fluxer_app/dist
  '';

  postInstall = ''
    mkdir -p $out/share/fluxer-app-proxy
    cp -r fluxer_app/dist/* $out/share/fluxer-app-proxy

    mv $out/share/fluxer_app_proxy $out/share/fluxer_app_proxy-unwrapped
    makeWrapper \
      $out/share/fluxer_app_proxy-unwrapped \
      $out/share/fluxer_app_proxy \
      --set-default FLUXER_STATIC_DIR $out/share/fluxer-app-proxy
  '';

  meta = {
    description = "A free and open source instant messaging and VoIP chat app";
    license = with lib.licenses; [
      agpl3Plus # fluxer
      cc-by-40 # fluxer_app/src/media/images/i-like-food.svg
      mit # fluxer_app/src/media/images/neko.png, fluxer_app/src/features/accessibility/components/NekoSprite.tsx
      asl20 # fluxer_app/src/features/ui/components/icons/InboxIcon.tsx
    ];
    homepage = "https://github.com/fluxerapp/fluxer";
    maintainers = [ lib.maintainers.strangeglyph ];
    mainProgram = "fluxer_app_proxy";
  };
})
