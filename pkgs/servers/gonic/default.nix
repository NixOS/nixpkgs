{ lib, buildGoPackage, fetchFromGitHub
, pkg-config, taglib, alsaLib

# Disable on-the-fly transcoding,
# removing the dependency on ffmpeg.
# The server will (as of 0.11.0) gracefully fall back
# to the original file, but if transcoding is configured
# that takes a while. So best to disable all transcoding
# in the configuration if you disable transcodingSupport.
, transcodingSupport ? true, ffmpeg

# udpater
, writers, vgo2nix }:

assert transcodingSupport -> ffmpeg != null;

let
  # update these, then run `updateScript` to update dependencies
  version = "0.11.0";
  rev = "056fb54a703ef5b5194ce112cbbdd8fb53dbb1ea";
  sha256 = "0hd794wrz29nh89lfnq67w1rc23sg085rqf1agwlgpqycns2djl9";

  src = fetchFromGitHub {
    owner = "sentriz";
    repo = "gonic";
    inherit rev sha256;
  };

in
buildGoPackage {
  pname = "gonic-${version}";
  inherit version src;
  goPackagePath = "go.senan.xyz/gonic";
  goDeps = ./deps.nix;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ taglib alsaLib ];

  postPatch = lib.optionalString transcodingSupport ''
    substituteInPlace \
       server/encode/encode.go \
      --replace \
        'ffmpegPath = "/usr/bin/ffmpeg"' \
        'ffmpegPath = "${ffmpeg}/bin/ffmpeg"' \
  '';

  passthru.updateScript = writers.writeDash "update-gonic" ''
    ${vgo2nix}/bin/vgo2nix \
      -dir ${src} \
      -outfile ${lib.escapeShellArg (toString ./deps.nix)}
  '';

  meta = {
    homepage = "https://github.com/sentriz/gonic";
    description = "Music streaming server / subsonic server API implementation";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ Profpatsch ];
  };
}
