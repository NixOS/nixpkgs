{ lib, buildGoModule, fetchFromGitHub
, pkg-config, taglib, alsaLib

# Disable on-the-fly transcoding,
# removing the dependency on ffmpeg.
# The server will (as of 0.11.0) gracefully fall back
# to the original file, but if transcoding is configured
# that takes a while. So best to disable all transcoding
# in the configuration if you disable transcodingSupport.
, transcodingSupport ? true, ffmpeg }:

assert transcodingSupport -> ffmpeg != null;
let
  pname = "gonic-${version}";
  version = "0.12.0";
in buildGoModule {
  inherit pname version;
  src = fetchFromGitHub {
    owner = "sentriz";
    repo = "gonic";
    rev = "v${version}";
    sha256 = "069hcsvx5rbdgxmkli0gkhgrvl47xb26vkfb7rr6dp06bx5nfhax";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ taglib alsaLib ];

  vendorSha256 = "0inxlqxnkglz4j14jav8080718a80nqdcl866lkql8r6zcxb4fm9";
  subPackages = [ "cmd/gonic" ];

  meta = {
    homepage = "https://github.com/sentriz/gonic";
    description = "Music streaming server / subsonic server API implementation";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ Profpatsch ];
  };
}
