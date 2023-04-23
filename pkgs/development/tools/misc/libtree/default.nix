{ lib
, stdenv
, fetchFromGitHub
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
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "haampie";
    repo = "libtree";
    rev = "v${version}";
    sha256 = "sha256-C5QlQsBL9Als80Tv13ex2XS5Yj50Ht8eDfGYAtnh/HI=";
  };

  buildInputs = [ cxxopts elfio termcolor ];

  makeFlags = [ "PREFIX=$(out)" ];

  # note: "make check" returns exit code 0 even when the tests fail.
  # This has been reported upstream:
  #  https://github.com/haampie/libtree/issues/77
  nativeCheckInputs = [ gtest ];
  checkTarget = [ "check" ];
  doCheck = true;

  meta = with lib; {
    description = "Tree ldd with an option to bundle dependencies into a single folder";
    homepage = "https://github.com/haampie/libtree";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ prusnak rardiol ];
  };
}
