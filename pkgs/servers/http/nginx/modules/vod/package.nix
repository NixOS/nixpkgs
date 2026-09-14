{
  lib,
  fetchFromGitHub,
  mkNginxPlugin,
  ffmpeg-headless,
  fdk_aac,
  openssl,
  libxml2,
  libiconv,
  nixosTests,
}:

mkNginxPlugin (finalAttrs: {
  pname = "vod";
  version = "1.9.2";

  src = fetchFromGitHub {
    owner = "dio-az";
    repo = "nginx-vod-module";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5j9GDXhENS1zgAXMoGB8PJvr5FwOxtsSi5H5dMjfN6w=";
  };

  postPatch = ''
    substituteInPlace vod/media_set.h \
      --replace-fail "MAX_CLIPS (128)" "MAX_CLIPS (1024)"
  '';

  buildInputs = [
    ffmpeg-headless
    fdk_aac
    openssl
    libxml2
    libiconv
  ];

  passthru.tests = { inherit (nixosTests) frigate; };

  meta = {
    changelog = "https://github.com/dio-az/nginx-vod-module/releases/tag/${finalAttrs.src.tag}";
    description = "VOD packager";
    homepage = "https://github.com/dio-az/nginx-vod-module";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.hexa ];
  };
})
