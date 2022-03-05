{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, binutils
, chrpath
, cmake
, cxxopts
, elfio
, termcolor
, gtest
}:

stdenv.mkDerivation rec {
  pname = "libtree";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "haampie";
    repo = "libtree";
    rev = "v${version}";
    sha256 = "sha256-j54fUwMkX4x4MwL8gMraguK9GqQRBjCC+W6ojFnQdHQ=";
  };

  patches = [
    # add missing include
    # https://github.com/haampie/libtree/pull/42
    (fetchpatch {
      url = "https://github.com/haampie/libtree/commit/219643ff6edcae42c9546b8ba38cfec9d19b034e.patch";
      sha256 = "sha256-vdFmmBdBiOT3QBcwd3SuiolcaFTFAb88kU1KN8229K0=";
    })
  ];

  postPatch = ''
    substituteInPlace src/main.cpp \
      --replace "std::string strip = \"strip\";" "std::string strip = \"${binutils}/bin/strip\";" \
      --replace "std::string chrpath = \"chrpath\";" "std::string chrpath = \"${chrpath}/bin/chrpath\";"
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = [ cxxopts elfio termcolor ];

  doCheck = true;

  checkInputs = [ gtest ];

  cmakeFlags = [ "-DLIBTREE_BUILD_TESTS=ON" ];

  meta = with lib; {
    description = "Tree ldd with an option to bundle dependencies into a single folder";
    homepage = "https://github.com/haampie/libtree";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ prusnak rardiol ];
  };
}
