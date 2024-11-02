{
  lib,
  buildPythonPackage,
  fetchPypi,
  scikit-build-core,
  cmake,
  ninja,
  setuptools-scm,
  bison,
  pcre2,
  swig,
}:
buildPythonPackage rec {
  pname = "swig";
  version = "4.2.1.post0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ksESZ91mulo/PqtdSjP1tHZhV7N4mEee4s+zUtm3Fok=";
  };

  build-system = [
    cmake
    ninja
    scikit-build-core
    setuptools-scm
  ];

  nativeBuildInputs = [
    bison
    pcre2
    swig
  ];

  patches = [
    # Makes sure scikit-build doesn't try to build the dependencies for us
    ./0001-stub.patch
  ];

  postPatch = ''
    substituteInPlace "src/swig/__init__.py" \
      --replace-fail "os.path.join(os.path.dirname(__file__), \"data\")" "\"${swig}\""
  '';

  dontUseCmakeConfigure = true;

  pythonImportChecks = [
    "swig"
  ];

  meta = {
    description = "SWIG bindings for python";
    homepage = "https://github.com/nightlark/swig-pypi";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ itepastra ];
  };
}
