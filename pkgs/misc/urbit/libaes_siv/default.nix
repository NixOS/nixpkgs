{ stdenv, sources, cmake, openssl, enableParallelBuilding ? true }:

stdenv.mkDerivation {
  name = "libaes_siv";
  version = sources.libaes_siv.rev;
  src = sources.libaes_siv;
  patches = [ ./cmakefiles_static.patch ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ openssl ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=OFF"
  ];

  inherit enableParallelBuilding;
}
