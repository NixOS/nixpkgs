{ stdenv, fetchFromGitHub
, cmake, pkgconfig, perl
, gettext, fuse, openssl, tinyxml2
}:

stdenv.mkDerivation rec {
  name = "encfs-${version}";
  version = "1.9.4";

  src = fetchFromGitHub {
    sha256 = "1hp2l4yk7fsimlrrd6a675vigmyikd323l1n3mybcdng58skj2ag";
    rev = "v${version}";
    repo = "encfs";
    owner = "vgough";
  };

  buildInputs = [ gettext fuse openssl tinyxml2 ];
  nativeBuildInputs = [ cmake pkgconfig perl ];

  cmakeFlags =
    [ "-DUSE_INTERNAL_TINYXML=OFF"
      "-DBUILD_SHARED_LIBS=ON"
      "-DINSTALL_LIBENCFS=ON"
    ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "An encrypted filesystem in user-space via FUSE";
    homepage = https://vgough.github.io/encfs;
    license = with licenses; [ gpl3 lgpl3 ];
    platforms = with platforms; linux;
  };
}
