{
  clangStdenv,
  cmake,
  fetchFromGitHub,
  lib,
}:
let
  pname = "base64";
  version = "0.5.0";
in
clangStdenv.mkDerivation {
  inherit pname version;
  src = fetchFromGitHub {
    owner = "aklomp";
    repo = "base64";
    rev = "v${version}";
    sha256 = "sha256-2HNI9ycT9f+NLwLElEuR61qmTguOsI+kNxv01ipxSqQ=";
  };
  nativeBuildInputs = [ cmake ];
  meta = with lib; {
    description = "Fast Base64 stream encoder/decoder in C99, with SIMD acceleration";
    license = licenses.bsd2;
    homepage = "https://github.com/aklomp/base64";
    maintainers = with maintainers; [ avakhrenev ];
    platforms = platforms.unix;
  };
}
