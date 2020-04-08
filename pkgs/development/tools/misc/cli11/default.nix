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
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "CLIUtils";
    repo = "CLI11";
    rev = "v${version}";
    sha256 = "1nqri8ahisi00nwh6cynhq5n9iq9iydkysnxj36r2y20yvbi4bxj";
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
