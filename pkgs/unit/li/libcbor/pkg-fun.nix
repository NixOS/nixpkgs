{ lib, stdenv, fetchFromGitHub, cmake, cmocka }:

stdenv.mkDerivation rec {
  pname = "libcbor";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "PJK";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Wp/48yQA17mf/dTgeMcMDvPpKOPkfLhQkCnzgGLpLtk=";
  };

  nativeBuildInputs = [ cmake ];
  nativeCheckInputs = [ cmocka ];

  doCheck = false; # needs "-DWITH_TESTS=ON", but fails w/compilation error

  cmakeFlags = [ "-DCMAKE_INSTALL_LIBDIR=lib" "-DBUILD_SHARED_LIBS=on" ];

  meta = with lib; {
    description = "CBOR protocol implementation for C and others";
    homepage = "https://github.com/PJK/libcbor";
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
  };
}
