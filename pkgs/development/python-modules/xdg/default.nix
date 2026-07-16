{
  lib,
  buildPythonPackage,
  fetchPypi,
  clikit,
  poetry-core,
}:

buildPythonPackage rec {
  version = "6.0.0";
  pname = "xdg";
  pyproject = true;

  # the github source uses `xdg_base_dirs`, but pypi's sdist maintains `xdg` for compatibility.
  # there are actually breaking changes in xdg_base_dirs,
  # and libraries that want to support python 3.9 and below need to use xdg.
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JCeAlPLUXoRtHrKKLruS17Z/wMq1JJ7jzojJX2SaHJI=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ clikit ];

  # sdist has no tests
  doCheck = false;

  pythonImportsCheck = [ "xdg" ];

  meta = {
    description = "XDG Base Directory Specification for Python";
    homepage = "https://github.com/srstevenson/xdg";
    license = lib.licenses.isc;
    maintainers = [ ];
  };
}
