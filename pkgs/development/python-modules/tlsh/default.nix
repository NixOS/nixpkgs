{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cmake,
  setuptools,
}:

buildPythonPackage rec {
  pname = "tlsh";
  version = "4.12.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "trendmicro";
    repo = "tlsh";
    tag = version;
    hash = "sha256-bR4598ZA7SDGInyxxjtBsttv+4XpZ+iqM7YAjlejdcU=";
  };

  patches = [
    # https://github.com/trendmicro/tlsh/pull/152
    ./cmake-4-compat.patch
  ];

  nativeBuildInputs = [ cmake ];

  build-system = [ setuptools ];

  # no test data
  doCheck = false;

  postConfigure = ''
    cd ../py_ext
  '';

  pythonImportsCheck = [ "tlsh" ];

  meta = {
    description = "Trend Micro Locality Sensitive Hash";
    homepage = "https://tlsh.org/";
    changelog = "https://github.com/trendmicro/tlsh/releases/tag/${version}";
    license = lib.licenses.asl20;
  };
}
