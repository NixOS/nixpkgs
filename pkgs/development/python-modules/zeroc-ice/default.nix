{
  lib,
  buildPythonPackage,
  pythonAtLeast,
  fetchPypi,
  setuptools,
  bzip2,
  openssl,
}:

buildPythonPackage rec {
  pname = "zeroc-ice";
  version = "3.7.10.1";
  pyproject = true;

  # Upstream PR: https://github.com/zeroc-ice/ice/pull/2910
  # But this hasn't been merged into the 3.7 branch, and the patch doesn't
  # apply cleanly.
  disabled = pythonAtLeast "3.13";

  src = fetchPypi {
    pname = "zeroc_ice";
    inherit version;
    hash = "sha256-sGOq/aNg33EfdpRVKbtUFXbyZr5B5dWi3Xf10yDBhmQ=";
  };

  build-system = [ setuptools ];

  buildInputs = [
    bzip2
    openssl
  ];

  pythonImportsCheck = [ "Ice" ];

  meta = with lib; {
    homepage = "https://zeroc.com/";
    license = licenses.gpl2;
    description = "Comprehensive RPC framework with support for Python, C++, .NET, Java, JavaScript and more";
    mainProgram = "slice2py";
    maintainers = [ ];
  };
}
