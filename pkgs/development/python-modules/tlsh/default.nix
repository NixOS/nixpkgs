{ lib
, buildPythonPackage
, fetchFromGitHub
, cmake
}:

buildPythonPackage {
  pname = "tlsh";
  version = "3.4.5";

  src = fetchFromGitHub {
    owner = "trendmicro";
    repo = "tlsh";
    rev = "22fa9a62068b92c63f2b5a87004a7a7ceaac1930";
    sha256 = "1ydliir308xn4ywy705mmsh7863ldlixdvpqwdhbipzq9vfpmvll";
  };

  nativeBuildInputs = [ cmake ];

  # no test data
  doCheck = false;

  postConfigure = ''
    cd ../py_ext
  '';

  meta = with lib; {
    description = "Trend Micro Locality Sensitive Hash";
    homepage = "https://github.com/trendmicro/tlsh";
    license = licenses.asl20;
    platforms = platforms.unix;
  };

}
