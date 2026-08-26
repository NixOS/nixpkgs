{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "should-dsl";
  version = "2.1.2";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "should_dsl";
    hash = "sha256-NvdT2Q+9+E7yt6ngeBPj76xyU3b+t6eTVJ8//3oDIyo=";
  };

  build-system = [ setuptools ];

  # There are no tests
  doCheck = false;

  pythonImportsCheck = [ "should_dsl" ];

  meta = {
    description = "Should assertions in Python as clear and readable as possible";
    homepage = "https://github.com/nsi-iff/should-dsl";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jluttine ];
  };
})
