{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  fetchpatch2,
  setuptools,
}:

buildPythonPackage rec {
  pname = "traits";
  version = "6.4.3";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qbv9ngwIt94H6G72TmnLlqKcIQWkO/gyzYsWL6HiL0Q=";
  };

  patches = [
    (fetchpatch2 {
      url = "https://github.com/enthought/traits/commit/a20f2154b2c79eb8550ea9228d1a4415ff51b72a.patch";
      hash = "sha256-ycStcpxlvmobL3ZXaSbGrXAzk/Tkjs3BJ67lnwZpeVA=";
      excludes = [ ".github/*" ];
    })
  ];

  build-system = [ setuptools ];

  pythonImportsCheck = [ "traits" ];

  meta = {
    description = "Explicitly typed attributes for Python";
    homepage = "https://pypi.python.org/pypi/traits";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
  };
}
