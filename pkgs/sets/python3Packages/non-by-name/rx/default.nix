{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
}:

buildPythonPackage rec {
  pname = "rx";
  version = "3.2.0";
  pyproject = true;

  # Use fetchPypi to avoid the updater script to migrate it to `reactivex` which
  # is being developed in the same repository
  src = fetchPypi {
    inherit version;
    pname = "Rx";
    hash = "sha256-tlfKK0WqSF2i99z9CfrC5VT3rFH/PC+PL/li7Nlj2Rw=";
  };

  build-system = [ setuptools ];

  doCheck = false; # PyPI tarball does not provides tests

  pythonImportsCheck = [ "rx" ];

  meta = {
    homepage = "https://github.com/ReactiveX/RxPY";
    description = "Reactive Extensions for Python";
    maintainers = with lib.maintainers; [ thanegill ];
    license = lib.licenses.asl20;
  };
}
