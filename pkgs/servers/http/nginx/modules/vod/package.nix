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
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "dio-az";
    repo = "nginx-vod-module";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IcXbbmAs16F9qOEJWgH6XqP5sBMYszclGByVghj0eBM=";
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

  passthru.tests = nixosTests.frigate;

  meta = {
    description = "VOD packager";
    homepage = "https://github.com/dio-az/nginx-vod-module";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.hexa ];
  };
})
