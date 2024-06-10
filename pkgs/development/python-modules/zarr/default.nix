{
  lib,
  asciitree,
  buildPythonPackage,
  fasteners,
  fetchPypi,
  numcodecs,
  msgpack,
  numpy,
  pytestCheckHook,
  pythonOlder,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "zarr";
  version = "2.17.2";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LLqmy040LUUVLUp6SyATwzf806jnvJglNWAYDeYFUs4=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    asciitree
    numpy
    fasteners
    numcodecs
  ] ++ numcodecs.optional-dependencies.msgpack;

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "zarr" ];

  meta = with lib; {
    description = "Implementation of chunked, compressed, N-dimensional arrays for Python";
    homepage = "https://github.com/zarr-developers/zarr";
    changelog = "https://github.com/zarr-developers/zarr-python/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
