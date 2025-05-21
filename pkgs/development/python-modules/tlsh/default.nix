{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cmake,
}:

buildPythonPackage rec {
  pname = "tlsh";
  version = "4.10.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "trendmicro";
    repo = "tlsh";
    rev = version;
    hash = "sha256-9Vkj7a5xU/coFyM/8i8JB0DdnbgDAEMOjmmMF8ckKuE=";
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
