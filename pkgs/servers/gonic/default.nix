{ lib, buildGoModule, fetchFromGitHub
, pkg-config, taglib, alsaLib

# Disable on-the-fly transcoding,
# removing the dependency on ffmpeg.
# The server will (as of 0.11.0) gracefully fall back
# to the original file, but if transcoding is configured
# that takes a while. So best to disable all transcoding
# in the configuration if you disable transcodingSupport.
, transcodingSupport ? true, ffmpeg }:

buildGoModule rec {
  pname = "gonic";
  version = "0.12.0";
  src = fetchFromGitHub {
    owner = "sentriz";
    repo = pname;
    rev = "6c69bd3be6279f743c83596c4f0fc12798fdb26a";
    sha256 = "1igb2lbkc1nfxp49id3yxql9sbdqr467661jcgnchcnbayj4d664";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ taglib alsaLib ];
  vendorSha256 = "0inxlqxnkglz4j14jav8080718a80nqdcl866lkql8r6zcxb4fm9";

  meta = {
    homepage = "https://github.com/sentriz/gonic";
    description = "Music streaming server / subsonic server API implementation";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ Profpatsch ];
  };
}
