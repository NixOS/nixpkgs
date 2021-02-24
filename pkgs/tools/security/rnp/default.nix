{ lib
, stdenv
, botan2
, bzip2
, cmake
, fetchFromGitHub
, json_c
, pkg-config
, zlib
}:
let
  version = "0.15.0";
in
stdenv.mkDerivation rec {
  pname = "rnp";
  inherit version;

  src = fetchFromGitHub {
    owner = "rnpgp";
    repo = "rnp";
    rev = "v${version}";
    sha256 = "1vpc37c3fb1lhfaywd0pzi42lw0vadav4xgdfkzlr27759hfmhxc";
  };

  buildInputs = [ zlib bzip2 json_c botan2 ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
    "-DBUILD_SHARED_LIBS=on"
    "-DBUILD_TESTING=off"
  ];

  nativeBuildInputs = [ cmake pkg-config ];

  outputs = [ "out" "lib" "dev" ];

  preConfigure = ''
    echo "v${version}" > version.txt
  '';

  meta = with lib; {
    homepage = "https://github.com/rnpgp/rnp";
    description = "High performance C++ OpenPGP library, fully compliant to RFC 4880";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = with maintainers; [ ribose-jeffreylau ];
  };
}
