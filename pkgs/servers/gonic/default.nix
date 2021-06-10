{ lib, buildGoModule, fetchFromGitHub
, pkg-config, taglib, alsa-lib
, zlib

# Disable on-the-fly transcoding,
# removing the dependency on ffmpeg.
# The server will (as of 0.11.0) gracefully fall back
# to the original file, but if transcoding is configured
# that takes a while. So best to disable all transcoding
# in the configuration if you disable transcodingSupport.
, transcodingSupport ? true, ffmpeg }:

buildGoModule rec {
  pname = "gonic";
  version = "0.12.2";
  src = fetchFromGitHub {
    owner = "sentriz";
    repo = pname;
    rev = "7d420f61a90739cd82a81c2740274c538405d950";
    sha256 = "0ix33cbhik1580h1jgv6n512dcgip436wmljpiw53c9v438k0ps5";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ taglib alsa-lib zlib ];
  vendorSha256 = "0inxlqxnkglz4j14jav8080718a80nqdcl866lkql8r6zcxb4fm9";

  # TODO(Profpatsch): write a test for transcoding support,
  # since it is prone to break
  postPatch = lib.optionalString transcodingSupport ''
    substituteInPlace \
      server/encode/encode.go \
      --replace \
        '"ffmpeg"' \
        '"${lib.getBin ffmpeg}/bin/ffmpeg"'
  '';

  meta = {
    homepage = "https://github.com/sentriz/gonic";
    description = "Music streaming server / subsonic server API implementation";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ Profpatsch ];
  };
}
