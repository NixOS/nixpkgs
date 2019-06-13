{ stdenv, fetchFromGitHub, cmake, gtest, python, boost }:

stdenv.mkDerivation rec {
  pname = "cli11";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "CLIUtils";
    repo = "CLI11";
    rev = "v${version}";
    sha256 = "0wddck970pczk7c201i2g6s85mkv4f2f4zxy6mndh3pfz41wcs2d";
  };

  nativeBuildInputs = [ cmake ];

  checkInputs = [ boost python ];

  doCheck = true;

  preConfigure = ''
    rm -rfv extern/googletest
    ln -sfv ${gtest.src} extern/googletest
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
