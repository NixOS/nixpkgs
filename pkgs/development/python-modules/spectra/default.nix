{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  colormath,
}:

buildPythonPackage rec {
  pname = "spectra";
  version = "0.0.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jsvine";
    repo = "spectra";
    rev = "v${version}";
    hash = "sha256-4A2TWTxYqckJ3DX5cd2KN3KXcmO/lQdXmOEnGi76RsA=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [ colormath ];

  pythonImportsCheck = [ "spectra" ];

  meta = {
    description = "Easy color scales and color conversion for Python";
    homepage = "https://github.com/jsvine/spectra";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ edmundmiller ];
  };
}
