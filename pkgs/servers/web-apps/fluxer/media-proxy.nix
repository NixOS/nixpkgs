{
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
  cacert,
  fetchFromGitHub,
  rustPlatform,
  lib,
  fluxerHashes,
  makeWrapper,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fluxer-media-proxy";
  inherit (fluxerHashes) version;

  src = fetchFromGitHub {
    owner = "fluxerapp";
    repo = "fluxer";
    inherit (fluxerHashes) rev hash;
  };

  cargoHash = fluxerHashes.cargo.hash;

  buildAndTestSubdir = "fluxer_media_proxy";

  nativeBuildInputs = [
    nasm
    yasm
    pkg-config
    makeWrapper
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

  # Seems like a mismatch with the upstream media libraries
  checkFlags = [
    "--skip=media_process::tests::animated_apng::apng_with_saturated_num_plays_clamps_per_format_instead_of_failing"
  ];

  postInstall = ''
    wrapProgram $out/bin/fluxer-media-proxy \
      --suffix LD_PRELOAD : ${jemalloc}/lib/libjemalloc.so \
      --set-default MALLOC_CONF "background_thread:true,metadata_thp:auto,dirty_decay_ms:5000,muzzy_decay_ms:5000" \
      --set-default VIPS_CONCURRENCY 1 \
      --set-default VIPS_DISC_THRESHOLD 1g
  '';

  meta = {
    description = "High-throughput media transcoding proxy for Fluxer, a free and open source instant messaging and VoIP chat app";
    license = lib.licenses.agpl3Plus;
    homepage = "https://github.com/fluxerapp/fluxer";
    maintainers = [ lib.maintainers.strangeglyph ];
    mainProgram = "fluxer-media-proxy";
  };
})
