{
  fetchFromGitHub,
  mkNginxPlugin,
  lib,
  ffmpeg-headless,
  libjpeg,
}:

mkNginxPlugin (finalAttrs: {
  pname = "video-thumbextractor";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "wandenberg";
    repo = "nginx-video-thumbextractor-module";
    tag = finalAttrs.version;
    hash = "sha256-F2cuzCbJdGYX0Zmz9MSXTB7x8+FBR6pPpXtLlDRCcj8=";
  };

  buildInputs = [
    ffmpeg-headless
    libjpeg
  ];

  meta = {
    description = "Extract thumbs from a video file";
    homepage = "https://github.com/wandenberg/nginx-video-thumbextractor-module";
    license = lib.licenses.gpl3;
    maintainers = [ ];
    broken = true;
  };
})
