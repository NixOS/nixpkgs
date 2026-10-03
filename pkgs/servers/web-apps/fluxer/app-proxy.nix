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

in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fluxer-app-proxy";
  version = "2026.1001.150203";

  src = fetchFromGitHub {
    owner = "fluxerapp";
    repo = "fluxer";
    tag = "${finalAttrs.pname}-self-hosted@${finalAttrs.version}";
    hash = "sha256-zs3T9gWmX7RzzpmumZ4OoNFYIKJc16r0yTujC5t8hY4=";
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
    hash = "sha256-oePyyvGyAPl4v5DVnsFtAl+Eu4I2Q6uOu6uOFHbO1dk=";
  };
  cargoExtraDeps = [
    (rustPlatform.fetchCargoVendor {
      inherit (finalAttrs) src;
      hash = "sha256-Z9N2jQtXkLPqJP2Fbu6xsNGN25XAE58CbHRm/f0uEIQ=";
      sourceRoot = "${finalAttrs.src.name}/fluxer_app/rust/libfluxcore";
    })
    (rustPlatform.fetchCargoVendor {
      inherit (finalAttrs) src;
      hash = "sha256-zz5JD3jiNCx8FOReZmCm4O2F20s7UbMsfZIM2sIcSS0=";
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
    hash = "sha256-PpuHVRJEO5B+D5m+BmIQErHyDmjiwwfVCSqntOs/ank=";
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
  '';

  meta = {
    description = "A free and open source instant messaging and VoIP chat app";
    license = lib.licenses.agpl3Only;
    homepage = "https://github.com/fluxerapp/fluxer";
    maintainers = [ lib.maintainers.strangeglyph ];
    # Execution note:
    # set FLUXER_STATIC_DIR=$out/share/fluxer-app-proxy
    mainProgram = "fluxer_app_proxy";
  };
})
