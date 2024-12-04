{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  scikit-build-core,
  cmake,
  pathspec,
  ninja,
  pyproject-metadata,
  setuptools-scm,

  # dependencies
  numpy,

  # tests
  pytestCheckHook,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "spglib";
  version = "2.5.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+LtjiJe+kbnb1MCF2f3h9pBI9ZSeIPODLLlDjldBjUs=";
  };

  nativeBuildInputs = [
    scikit-build-core
    cmake
    pathspec
    ninja
    pyproject-metadata
    setuptools-scm
  ];

  dontUseCmakeConfigure = true;

  postPatch = ''
    # relax v2 constrain in [build-system] intended for binary backward compat
    substituteInPlace pyproject.toml \
      --replace-fail "numpy~=2.0" "numpy"
  '';

  propagatedBuildInputs = [ numpy ];

  nativeCheckInputs = [
    pytestCheckHook
    pyyaml
  ];

  pythonImportsCheck = [ "spglib" ];

  meta = with lib; {
    description = "Python bindings for C library for finding and handling crystal symmetries";
    homepage = "https://spglib.github.io/spglib/";
    changelog = "https://github.com/spglib/spglib/raw/v${version}/ChangeLog";
    license = licenses.bsd3;
    maintainers = with maintainers; [ psyanticy ];
  };
}
