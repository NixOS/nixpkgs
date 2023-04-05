{ lib, buildPythonPackage, fetchPypi, click, tomli }:

buildPythonPackage rec {
  pname = "turnt";
  version = "1.9.0";
  format = "flit";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-X0uJmY2MVnvM50LDBXDn9hK4NuHAil4Kf39V/8b8OIQ=";
  };

  propagatedBuildInputs = [
    click
    tomli
  ];

  doCheck = true;

  checkPhase = ''
    runHook preCheck
    $out/bin/turnt test/*/*.t
    runHook postCheck
  '';

  pythonImportsCheck = [ "turnt" ];

  meta = with lib; {
    description = "Snapshot testing tool";
    homepage = "https://github.com/cucapra/turnt";
    license = licenses.mit;
    maintainers = with maintainers; [ leungbk ];
  };
}
