{ lib
, buildPythonPackage
, fetchFromGitHub
, cmake
}:

buildPythonPackage {
  pname = "tlsh";
  version = "4.5.0";

  src = fetchFromGitHub {
    owner = "trendmicro";
    repo = "tlsh";
    rev = "f2bb7a97cfb0f9418a750ba92c182d1091e6c159";
    sha256 = "1kxfhdwqjd4pjdlr1gjh2am8mxpaqmfq7rrxkjfi0mbisl1krkwb";
  };

  nativeBuildInputs = [ cmake ];

  # no test data
  doCheck = false;

  postConfigure = ''
    cd ../py_ext
  '';

  meta = with lib; {
    description = "Trend Micro Locality Sensitive Hash";
    homepage = "http://tlsh.org/";
    license = licenses.asl20;
    platforms = platforms.unix;
  };

}
