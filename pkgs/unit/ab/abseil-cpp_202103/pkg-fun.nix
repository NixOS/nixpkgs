{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, static ? stdenv.hostPlatform.isStatic
, cxxStandard ? null
}:

stdenv.mkDerivation rec {
  pname = "abseil-cpp";
  version = "20210324.2";

  src = fetchFromGitHub {
    owner = "abseil";
    repo = "abseil-cpp";
    rev = version;
    sha256 = "sha256-fcxPhuI2eL/fnd6nT11p8DpUNwGNaXZmd03yOiZcOT0=";
  };

  patches = [
    # Use CMAKE_INSTALL_FULL_{LIBDIR,INCLUDEDIR}
    # https://github.com/abseil/abseil-cpp/pull/963
    (fetchpatch {
      url = "https://github.com/abseil/abseil-cpp/commit/5bfa70c75e621c5d5ec095c8c4c0c050dcb2957e.patch";
      sha256 = "0nhjxqfxpi2pkfinnqvd5m4npf9l1kg39mjx9l3087ajhadaywl5";
    })
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=${if static then "OFF" else "ON"}"
  ] ++ lib.optionals (cxxStandard != null) [
    "-DCMAKE_CXX_STANDARD=${cxxStandard}"
  ];

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "An open-source collection of C++ code designed to augment the C++ standard library";
    homepage = "https://abseil.io/";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = [ maintainers.andersk ];
  };
}
