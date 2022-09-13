{ lib
, stdenv
, asciidoctor
, botan2
, bzip2
, cmake
, fetchFromGitHub
, fetchpatch
, gnupg
, gtest
, json_c
, pkg-config
, python3
, zlib
}:

stdenv.mkDerivation rec {
  pname = "rnp";
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "rnpgp";
    repo = "rnp";
    rev = "v${version}";
    sha256 = "sha256-EpmQ9dCbc46OEbWJy/9wi/WKAZ14azCojpS5k6Awx6w=";
  };

  # in master post 0.16.0, see https://github.com/rnpgp/rnp/issues/1835
  patches = [
    (fetchpatch {
      name = "fix-pkg-config.patch";
      url = "https://github.com/rnpgp/rnp/commit/de9856c94ea829cad277800ee03ec52e30993d8e.patch";
      sha256 = "1vd83fva7lhmvqnvsrifqb2zdhfrbx84lf3l9i0hcph0k8h3ddx9";
    })
  ];

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
