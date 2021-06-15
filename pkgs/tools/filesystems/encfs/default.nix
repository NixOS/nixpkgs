{ lib, stdenv, fetchFromGitHub
, cmake, pkg-config, perl
, gettext, fuse, openssl, tinyxml2
}:

stdenv.mkDerivation rec {
  pname = "encfs";
  version = "1.9.5";

  src = fetchFromGitHub {
    sha256 = "099rjb02knr6yz7przlnyj62ic0ag5ncs7vvcc36ikyqrmpqsdch";
    rev = "v${version}";
    repo = "encfs";
    owner = "vgough";
  };

  buildInputs = [ gettext fuse openssl tinyxml2 ];
  nativeBuildInputs = [ cmake pkg-config perl ];

  cmakeFlags =
    [ "-DUSE_INTERNAL_TINYXML=OFF"
      "-DBUILD_SHARED_LIBS=ON"
      "-DINSTALL_LIBENCFS=ON"
    ];

  meta = with lib; {
    description = "An encrypted filesystem in user-space via FUSE";
    homepage = "https://vgough.github.io/encfs";
    license = with licenses; [ gpl3Plus lgpl3Plus ];
    platforms = platforms.unix;
  };
}
