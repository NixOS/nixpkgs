{ lib, buildPythonPackage, fetchPypi, click, tomli }:

buildPythonPackage rec {
  pname = "turnt";
  version = "1.8.0";
  format = "flit";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c6cfcb68a3353032c4ce6fff352196e723d05f9cee23eaf4f36d4dcfd89b8e49";
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
