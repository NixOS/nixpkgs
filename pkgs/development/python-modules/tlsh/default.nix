{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cmake,
  setuptools,
}:

buildPythonPackage rec {
  pname = "tlsh";
  version = "4.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "trendmicro";
    repo = "tlsh";
    rev = "refs/tags/${version}";
    hash = "sha256-Ht4LkcNmxPEvzFHXeS/XhPt/xo+0sE4RBcLCn9N/zwE=";
  };

  nativeBuildInputs = [ cmake ];

  build-system = [ setuptools ];

  # no test data
  doCheck = false;

  postConfigure = ''
    cd ../py_ext
  '';

  pythonImportsCheck = [ "tlsh" ];

  meta = with lib; {
    description = "Trend Micro Locality Sensitive Hash";
    homepage = "https://tlsh.org/";
    changelog = "https://github.com/trendmicro/tlsh/releases/tag/${version}";
    license = licenses.asl20;
  };
}
