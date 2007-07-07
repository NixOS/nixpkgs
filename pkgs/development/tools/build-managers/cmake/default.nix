{stdenv, fetchurl}:
stdenv.mkDerivation {
  name = "cmake-2.4.6";

  src = fetchurl {
    url = http://www.cmake.org/files/v2.4/cmake-2.4.6.tar.gz;
    sha256 = "0163q13gw9ff28dpbwq23h83qfqabvcxrzsi9cjpyc9dfg7jpf5g";
  };

  buildInputs = [];

  meta = {
    description = "
CMake. Make flavour used by cdrkit.
";
  };
}
