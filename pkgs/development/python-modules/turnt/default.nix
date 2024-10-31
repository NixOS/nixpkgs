{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  click,
  tomli,
}:

buildPythonPackage rec {
  pname = "turnt";
  version = "1.12.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4K7cqGwKErGbZ+dxVa06v8aIfrpVLC293d29QT+vsBw=";
  };

  build-system = [ flit-core ];

  dependencies = [
    click
    tomli
  ];

  checkPhase = ''
    runHook preCheck
    $out/bin/turnt test/*/*.t
    runHook postCheck
  '';

  pythonImportsCheck = [ "turnt" ];

  meta = with lib; {
    description = "Snapshot testing tool";
    mainProgram = "turnt";
    homepage = "https://github.com/cucapra/turnt";
    license = licenses.mit;
    maintainers = with maintainers; [ leungbk ];
  };
}
