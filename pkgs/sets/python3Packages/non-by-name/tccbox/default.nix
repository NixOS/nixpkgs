{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  tinycc,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "tccbox";
  version = "0-unstable-2025-08-26";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "metab0t";
    repo = "tccbox";
    rev = "c46dd0587b70fae9b0be2bf76a2ba13e3f293d3a";
    hash = "sha256-cCaDbFDiQmmKY+MhALT5FY7e5929qzyvVJhhnmo6BIY=";
  };

  postPatch = ''
    mkdir tinycc
    cp --recursive ${tinycc.out} tinycc/tcc_dist
    sed -i '/^[[:space:]]*build_tinycc()[[:space:]]*$/d' setup.py
  '';

  build-system = [ setuptools ];

  postCheck = ''
    tinycc/tcc_dist/bin/tcc test/fib.c -o test/fib
    test/fib
  '';

  pythonImportsCheck = [ "tccbox" ];

  meta = {
    description = "PyPI package of tiny c compiler";
    homepage = "https://github.com/metab0t/tccbox";
    license = lib.licenses.lgpl2Only;
    maintainers = with lib.maintainers; [ kyehn ];
  };
}
