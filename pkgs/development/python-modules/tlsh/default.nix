{ lib
, buildPythonPackage
, fetchFromGitHub
, cmake
}:

buildPythonPackage rec {
  pname = "tlsh";
  version = "4.9.3";

  src = fetchFromGitHub {
    owner = "trendmicro";
    repo = "tlsh";
    rev = version;
    sha256 = "sha256-12bhxJTJJWzoiWt4YwhcdwHDvJNoBenWl3l26SFuIGU=";
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
