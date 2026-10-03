{
  pkg-config,
  vips,
  libheif,
  ffmpeg,
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
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fluxer-media-proxy";
  version = "2026.1003.2520";

  src = fetchFromGitHub {
    owner = "fluxerapp";
    repo = "fluxer";
    tag = "${finalAttrs.pname}@${finalAttrs.version}";
    hash = "sha256-NHMB7FoBK1ccg8rt94NwN8FMsHSPQSCH1YPN2p2gnKU=";
  };

  cargoLock.lockFile = "${finalAttrs.src}/Cargo.lock";
  buildAndTestSubdir = "fluxer_media_proxy";

  nativeBuildInputs = [
    pkg-config
  ];

  nativeCheckInputs = [
    cacert
  ];

  buildInputs = [
    vips
    libheif
    ffmpeg
    lcms2
    libwebp
    libyuv
    libde265
    dav1d
    libaom
  ];

  meta = {
    description = "A free and open source instant messaging and VoIP chat app";
    license = lib.licenses.agpl3Only;
    homepage = "https://github.com/fluxerapp/fluxer";
    maintainers = [ lib.maintainers.strangeglyph ];
    mainProgram = "fluxer-media-proxy";
  };
})
