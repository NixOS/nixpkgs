{
  stdenv,
  fetchFromGitHub,
  cmake,
  gtest,
  python,
  boost
}:

stdenv.mkDerivation rec {
  pname = "cli11";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "CLIUtils";
    repo = "CLI11";
    rev = "v${version}";
    sha256 = "0i1x4ax5hal7jdsxw40ljwfv68h0ac85iyi35i8p52p9s5qsc71q";
  };

  nativeBuildInputs = [ cmake ];

  checkInputs = [ boost python ];

  doCheck = true;

  preConfigure = ''
    rm -rfv extern/googletest
    ln -sfv ${gtest.src} extern/googletest
    sed -i '/TrueFalseTest/d' tests/CMakeLists.txt
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "CLI11 is a command line parser for C++11";
    homepage = https://github.com/CLIUtils/CLI11;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ nand0p ];
    license = licenses.unfreeRedistributable;
  };

}
