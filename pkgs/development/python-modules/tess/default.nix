{
  lib,
  buildPythonPackage,
  fetchPypi,
  cython,
  setuptools,
  numpy,
  scipy,
  pytestCheckHook,
  python,
}:

buildPythonPackage rec {
  pname = "tess";
  version = "0.3.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5Ic06+K7CWRh1t2v3aJ5JlBACvHXqQyYzvU71jZJFtI=";
  };

  build-system = [
    cython
    setuptools
  ];

  dependencies = [
    numpy
    scipy
  ];

  # scipy has depecrated since version 1.15.0 the function `sph_harm`, and has
  # been removed in 1.17.0 in favor of `sph_harm_y`
  patches = [ ./scipy_sph_harm.patch ];

  pythonImportsCheck = [ "tess" ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "tess/tests.py" ];

  preCheck = ''
    cd $out/${python.sitePackages}
  '';

  meta = {
    description = "Module for calculating and analyzing Voronoi tessellations";
    homepage = "https://tess.readthedocs.org";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
