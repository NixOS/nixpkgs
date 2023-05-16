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
<<<<<<< HEAD
, sexpp
, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rnp";
  version = "0.17.0";
=======
, zlib
}:

stdenv.mkDerivation rec {
  pname = "rnp";
  version = "0.16.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "rnpgp";
    repo = "rnp";
<<<<<<< HEAD
    rev = "v${finalAttrs.version}";
    hash = "sha256-4fB7Sl9+ATrJTRnhbNG5BoW3XLxR7IP167RK96+gxj0=";
  };

  buildInputs = [ zlib bzip2 json_c botan2 sexpp ];

  patches = [
    ./unbundle-sexpp.patch
    ./sexp_sexpp_rename.patch
  ];
=======
    rev = "v${version}";
    sha256 = "sha256-kM3gBc5rbLJU7UXvWz4a9c+Ahi/d0z8R9S5t0B9Fts0=";
  };

  buildInputs = [ zlib bzip2 json_c botan2 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
    "-DBUILD_SHARED_LIBS=on"
    "-DBUILD_TESTING=on"
    "-DDOWNLOAD_GTEST=off"
    "-DDOWNLOAD_RUBYRNP=off"
  ];

  nativeBuildInputs = [ asciidoctor cmake gnupg gtest pkg-config python3 ];

  # NOTE: check-only inputs should ideally be moved to nativeCheckInputs, but it
  # would fail during buildPhase.
  # nativeCheckInputs = [ gtest python3 ];

  outputs = [ "out" "lib" "dev" ];

  preConfigure = ''
<<<<<<< HEAD
    echo "v${finalAttrs.version}" > version.txt
=======
    echo "v${version}" > version.txt
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  meta = with lib; {
    homepage = "https://github.com/rnpgp/rnp";
    description = "High performance C++ OpenPGP library, fully compliant to RFC 4880";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = with maintainers; [ ribose-jeffreylau ];
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
