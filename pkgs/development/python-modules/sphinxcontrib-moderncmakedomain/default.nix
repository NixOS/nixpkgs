{ lib
, buildPythonPackage
, defusedxml
, fetchPypi
, hatchling
, pytest
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-moderncmakedomain";
  version = "3.29.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "sphinxcontrib_moderncmakedomain";
    hash = "sha256-NYfe8kH/JXfQu+8RgQoILp3sG3ij1LSgZiQLXz3BtbI=";
  };

  nativeBuildInputs = [
    hatchling
    sphinx
  ];

  nativeCheckInputs = [
    defusedxml
    pytest
    sphinx
  ];

  checkPhase = ''
    runHook preCheck
    pytest tests/
    runHook postCheck
  '';

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = with lib; {
    description = "Sphinx extension which renders CMake documentation";
    homepage = "https://github.com/scikit-build/moderncmakedomain";
    license = licenses.bsd3;
    maintainers = teams.sphinx.members;
  };
}
