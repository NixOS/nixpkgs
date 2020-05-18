{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, opencv
}:
stdenv.mkDerivation rec {

  pname = "zxing-cpp";
  version = "0.0";

  src = fetchFromGitHub {
    owner = "glassechidna";
    repo = "zxing-cpp";
    # No release tag yet, defaulting to latest commit
    rev = "e0e40ddec63f38405aca5c8c1ff60b85ec8b1f10";
    sha256 = "03mbqf156047nqmq00qkwk9lvcmi9iknim2b2jv59h9qywjzypxq";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ opencv ];

  meta = {
    description = "Zebra Crossing barcode scanning library ported to c++";
    license = lib.licenses.asl20;
    homepage = "https://github.com/glassechidna/zxing-cpp";
    maintainers = with lib.maintainers; [ shamilton ];
    platforms = stdenv.lib.platforms.linux;
  };
}
