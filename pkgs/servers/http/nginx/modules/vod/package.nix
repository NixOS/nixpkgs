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
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "dio-az";
    repo = "nginx-vod-module";
    tag = "v${finalAttrs.version}";
    hash = "sha256-18LA3Thiz4EnVkRp6j5BuTyIcd0zXgyyvW6yuzm7vRs=";
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
