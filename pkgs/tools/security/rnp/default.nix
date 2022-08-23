{ lib
, stdenv
, asciidoctor
, botan2
, bzip2
, cmake
, fetchFromGitHub
, gnupg
, gtest
, json_c
, pkg-config
, python3
, zlib
}:

stdenv.mkDerivation rec {
  pname = "rnp";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "rnpgp";
    repo = "rnp";
    rev = "v${version}";
    sha256 = "u0etVslTBF9fBqnpVBofYsm0uC/eR6gO3lhwzqua5Qw=";
  };

  buildInputs = [ zlib bzip2 json_c botan2 ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
    "-DBUILD_SHARED_LIBS=on"
    "-DBUILD_TESTING=on"
    "-DDOWNLOAD_GTEST=off"
    "-DDOWNLOAD_RUBYRNP=off"
  ];

  nativeBuildInputs = [ asciidoctor cmake gnupg gtest pkg-config python3 ];

  # NOTE: check-only inputs should ideally be moved to checkInputs, but it
  # would fail during buildPhase.
  # checkInputs = [ gtest python3 ];

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
