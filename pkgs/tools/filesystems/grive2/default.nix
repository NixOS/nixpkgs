{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, pkg-config
, yajl
, cmake
, libgcrypt
, curl
, expat
, boost
, libiberty
}:

stdenv.mkDerivation rec {
  version = "0.5.3";
  pname = "grive2";

  src = fetchFromGitHub {
    owner = "vitalif";
    repo = "grive2";
    rev =  "v${version}";
    sha256 = "sha256-P6gitA5cXfNbNDy4ohRLyXj/5dUXkCkOdE/9rJPzNCg=";
  };

  patches = [
    # Backport gcc-12 support:
    #   https://github.com/vitalif/grive2/pull/363
    (fetchpatch {
      name = "gcc-12.patch";
      url = "https://github.com/vitalif/grive2/commit/3cf1c058a3e61deb370dde36024a106a213ab2c6.patch";
      hash = "sha256-v2Pb6Qvgml/fYzh/VCjOvEVnFYMkOHqROvLLe61DmKA=";
    })
  ];

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ libgcrypt yajl curl expat boost libiberty ];

  meta = with lib; {
    description = "A console Google Drive client";
    homepage = "https://github.com/vitalif/grive2";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    mainProgram = "grive";
  };
}
