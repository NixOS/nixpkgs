{
  runCommand,
  callPackage,
  fetchFromGitHub,
  fetchPnpmDeps,
  rustPlatform,
  nodejs_26,
  pnpm_11,
  lib,
  ...
}:
let
  fluxerHashes = lib.importJSON ./pin.json;
  copyCargoDeps =
    deps:
    ''cp -r --no-clobber --no-preserve=mode "${deps}/source-registry-0/." "$out/source-registry-0/"'';
  mergeCargoDeps =
    # merge several `fetchCargoVendor` derivations into one store
    # the primary (`root-dep`) derivation also provides the Cargo.lock that cargoDeps expects
    root-dep: extra-dep-list:
    runCommand "merge-vendor-deps" { } ''
      mkdir -p $out

      cp -r --no-preserve=mode "${root-dep}/." "$out/"

      ${lib.join "\n" (lib.map copyCargoDeps extra-dep-list)}
    '';
  src = fetchFromGitHub {
    owner = "fluxerapp";
    repo = "fluxer";
    inherit (fluxerHashes) rev hash;
  };
  cargoPrimaryDeps = rustPlatform.fetchCargoVendor {
    inherit (src) ;
    inherit (fluxerHashes.cargo) hash;
  };
  cargoLibFluxcoreDeps = rustPlatform.fetchCargoVendor {
    inherit (src) ;
    hash = fluxerHashes.cargo.libFluxcore;
    sourceRoot = "${src.name}/fluxer_app/rust/libfluxcore";
  };
  cargoLibFluxwebpDeps = rustPlatform.fetchCargoVendor {
    inherit (src) ;
    hash = fluxerHashes.cargo.libFluxwebp;
    sourceRoot = "${src.name}/fluxer_app/rust/libfluxwebp";
  };
  cargoLibGuildMemberListNifDeps = rustPlatform.fetchCargoVendor {
    inherit (src) ;
    hash = fluxerHashes.cargo.libGuildMemberListNif;
    sourceRoot = "${src.name}/fluxer_gateway/native/guild_member_list_oset_nif";
  };
  cargoLibMarkdownPlaintextNifDeps = rustPlatform.fetchCargoVendor {
    inherit (src) ;
    hash = fluxerHashes.cargo.libPushMarkdownPlaintext;
    sourceRoot = "${src.name}/fluxer_gateway/native/push_markdown_plaintext_nif";
  };
  cargoDeps = mergeCargoDeps cargoPrimaryDeps [
    cargoLibFluxcoreDeps
    cargoLibFluxwebpDeps
    cargoLibGuildMemberListNifDeps
    cargoLibMarkdownPlaintextNifDeps
  ];
  nodejs = nodejs_26;
  pnpm = pnpm_11.override { nodejs-slim = nodejs; };
  pnpmDeps = fetchPnpmDeps {
    inherit src;
    inherit pnpm;
    pname = "fluxer-pnpm-deps-0";
    fetcherVersion = 4;
    hash = fluxerHashes.pnpm;
  };
in
{
  fluxer-admin = callPackage ./admin.nix { inherit fluxerHashes; };
  fluxer-api = callPackage ./api.nix { inherit fluxerHashes; };
  fluxer-app-proxy = callPackage ./app-proxy.nix { inherit fluxerHashes; };
  fluxer-gateway = callPackage ./gateway.nix { inherit fluxerHashes; };
  fluxer-gifs = callPackage ./gifs.nix { inherit fluxerHashes; };
  fluxer-media-proxy = callPackage ./media-proxy.nix { inherit fluxerHashes; };
  fluxer-messages = callPackage ./messages.nix { inherit fluxerHashes; };
  fluxer-push = callPackage ./push.nix { inherit fluxerHashes; };
  fluxer-snowflakes = callPackage ./snowflakes.nix { inherit fluxerHashes; };
  fluxer-static = callPackage ./static.nix { inherit fluxerHashes; };
  fluxer-unfurl = callPackage ./unfurl.nix { inherit fluxerHashes; };
  fluxer-users = callPackage ./users.nix { inherit fluxerHashes; };
  fluxer-rust-packages = callPackage ./rust-packages.nix { inherit fluxerHashes cargoDeps pnpmDeps; };
}
