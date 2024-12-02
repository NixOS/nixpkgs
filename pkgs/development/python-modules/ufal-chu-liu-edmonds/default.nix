{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  numpy,
}:

buildPythonPackage rec {
  pname = "ufal-chu-liu-edmonds";
  version = "1.0.3";
  pyproject = true;

  src = fetchPypi {
    pname = "ufal.chu_liu_edmonds";
    inherit version;
    hash = "sha256-v3tv6cYWoFPPgaO6KXR2uUk3MsZ458Tz5wKeFW8fzNE=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ numpy ];

  checkPhase = ''
    runHook preCheck
    cd tests
    python test.py
    runHook postCheck
  '';

  pythonImportsCheck = [ "ufal.chu_liu_edmonds" ];

  meta = with lib; {
    description = "Bindings to Chu-Liu-Edmonds algorithm from TurboParser";
    homepage = "https://github.com/ufal/chu_liu_edmonds";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ vizid ];
  };
}
