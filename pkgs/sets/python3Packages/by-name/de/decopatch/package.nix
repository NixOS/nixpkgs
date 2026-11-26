{
  lib,
  buildPythonPackage,
  fetchPypi,
  makefun,
  setuptools_80,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "decopatch";
  version = "1.4.10";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lX9JyT9BUBgsI/j7UdE7syE+DxenngnIzKcFdZi1VyA=";
  };

  build-system = [
    setuptools_80
    setuptools-scm
  ];

  dependencies = [ makefun ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "pytest-runner" ""
  '';

  pythonImportsCheck = [ "decopatch" ];

  # Tests would introduce multiple circular dependencies
  # Affected: makefun, pytest-cases
  doCheck = false;

  meta = {
    description = "Python helper for decorators";
    homepage = "https://github.com/smarie/python-decopatch";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
}
