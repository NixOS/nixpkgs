{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cmake,
  setuptools,
}:

buildPythonPackage rec {
  pname = "tlsh";
  version = "5.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "trendmicro";
    repo = "tlsh";
    tag = version;
    hash = "sha256-cYvXZrd+8ZC5LfucguFFNlEX8FR+AkchmCFButYoiMg=";
  };

  patches = [
    # https://github.com/trendmicro/tlsh/pull/152
    ./cmake-4-compat.patch
  ];

  postPatch = ''
    substituteInPlace py_ext/setup.py \
      --replace-fail "4.5.0" "${version}"
  '';

  nativeBuildInputs = [ cmake ];

  postConfigure = ''
    cd ../py_ext
  '';

  build-system = [ setuptools ];

  # no test data
  doCheck = false;

  pythonImportsCheck = [ "tlsh" ];

  meta = {
    description = "Trend Micro Locality Sensitive Hash";
    homepage = "https://tlsh.org/";
    changelog = "https://github.com/trendmicro/tlsh/releases/tag/${version}";
    license = lib.licenses.asl20;
  };
}
