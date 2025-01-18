{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  parsley,
  twisted,
  python,
}:

buildPythonPackage rec {
  pname = "txi2p-tahoe";
  version = "0.3.7";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "tahoe-lafs";
    repo = "txi2p";
    tag = version;
    hash = "sha256-u/IOhxK9jWC/tTKKLsc4PexbCuki+yEtMNw7LuQKmuk=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    parsley
    twisted
  ];

  pythonImportsCheck = [ "txi2p" ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m twisted.trial txi2p
    runHook postCheck
  '';

  meta = with lib; {
    description = "I2P bindings for Twisted";
    homepage = "https://github.com/tahoe-lafs/txi2p";
    license = licenses.isc;
    maintainers = with maintainers; [ dotlambda ];
  };
}
