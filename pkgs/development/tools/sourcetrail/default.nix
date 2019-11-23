{ stdenv, fetchFromGitHub, cmake, imagemagick
, boost, dbus, expat, git, openssl, python3, qt5, zlib }:

stdenv.mkDerivation rec {
  pname = "sourcetrail";
  version = "2019.4.61";

  src = fetchFromGitHub {
    owner = "CoatiSoftware";
    repo = pname;
    rev = version;
    sha256 = "0srv5nnyhbxssb3ss94i3j0270rw1p0z9w2c8s96n94f5nksri7c";
  };

  patches = [ ./cmake-boost-shared-lib.patch ];

  # Qt5_DIR should be specified manually
  # See https://github.com/CoatiSoftware/Sourcetrail#for-unix
  cmakeFlags = [ "-DQt5_DIR=${qt5.qtbase.dev}/lib/cmake/Qt5" ];

  # Should fix "undefined shm_open"
  # https://stackoverflow.com/questions/9923495/undefined-reference-shm-open-already-add-lrt-flag-here
  NIX_LDFLAGS = [ "-lrt" ];

  nativeBuildInputs = [ cmake imagemagick ];
  buildInputs = [ boost dbus expat git openssl python3 zlib ]
    ++ (with qt5; [ qtbase qtsvg ]);

  meta = with stdenv.lib; {
    homepage = "https://www.sourcetrail.com";
    description = "A cross-platform source explorer for C/C++ and Java";
    platforms = platforms.all;
    license = licenses.gpl3;
    maintainers = with maintainers; [ filalex77 midchildan ];
  };
}
