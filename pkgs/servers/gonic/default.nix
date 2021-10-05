{ lib, stdenv, buildGoModule, fetchFromGitHub
, pkg-config, taglib, alsa-lib
, zlib, AudioToolbox, AppKit

# Disable on-the-fly transcoding,
# removing the dependency on ffmpeg.
# The server will (as of 0.11.0) gracefully fall back
# to the original file, but if transcoding is configured
# that takes a while. So best to disable all transcoding
# in the configuration if you disable transcodingSupport.
, transcodingSupport ? true, ffmpeg }:

buildGoModule rec {
  pname = "gonic";
  version = "0.14.0";
  src = fetchFromGitHub {
    owner = "sentriz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-wX97HtvHgHpKTDwZl/wHQRpiyDJ7U38CpdzWu/CYizQ=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ taglib zlib ]
    ++ lib.optionals stdenv.isLinux [ alsa-lib ]
    ++ lib.optionals stdenv.isDarwin [ AudioToolbox AppKit ];
  vendorSha256 = "sha256-oTuaA5ZsZ7zMcjzGh37zO/1XyOfj6xjfNr6A7ecrOiA=";

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
