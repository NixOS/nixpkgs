{ stdenv, fetchFromGitHub
, cmake, pkgconfig, perl
, gettext, fuse, openssl, tinyxml2
}:

stdenv.mkDerivation rec {
  name = "encfs-${version}";
  version = "1.9.2";

  src = fetchFromGitHub {
    sha256 = "0isx7n4r8znk02464s0wvlzk6ry5mlnq3kgnd0rapnhjwdvwqr5y";
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
    maintainers = with maintainers; [ nckx ];
    platforms = with platforms; linux;
  };
}
