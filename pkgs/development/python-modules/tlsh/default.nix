{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cmake,
}:

buildPythonPackage rec {
  pname = "tlsh";
  version = "4.12.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "trendmicro";
    repo = "tlsh";
    rev = "refs/tags/${version}";
    hash = "sha256-Ht4LkcNmxPEvzFHXeS/XhPt/xo+0sE4RBcLCn9N/zwE=";
  };

  nativeBuildInputs = [ cmake ];

  # no test data
  doCheck = false;

  postConfigure = ''
    cd ../py_ext
  '';

  meta = with lib; {
    description = "Trend Micro Locality Sensitive Hash";
    homepage = "https://tlsh.org/";
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
