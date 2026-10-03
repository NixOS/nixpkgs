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
let
  versioning = lib.importJSON ./versioning.json;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fluxer-media-proxy";
  inherit (versioning) version cargoHash;

  src = fetchFromGitHub {
    owner = "fluxerapp";
    repo = "fluxer";
    inherit (versioning) rev hash;
  };

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
