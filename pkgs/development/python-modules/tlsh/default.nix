{ lib
, buildPythonPackage
, fetchFromGitHub
, cmake
}:

buildPythonPackage {
  pname = "tlsh";
  version = "4.6.0";

  src = fetchFromGitHub {
    owner = "trendmicro";
    repo = "tlsh";
    rev = "b2ff80316a66bbb6f4560df12bdf5d00461f491f";
    sha256 = "1hrg0c0nlgaapgn1x3pa4f18512vjfigcj3xzm1829icwj49ybz4";
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
