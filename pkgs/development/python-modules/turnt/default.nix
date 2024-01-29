{ lib, buildPythonPackage, fetchPypi, flit, click, tomli }:

buildPythonPackage rec {
  pname = "turnt";
  version = "1.11.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XN+qzRgZMSdeBmW0OM36mQ79sRCuP8E++SqH8FOoEq0=";
  };

  nativeBuildInputs = [
    flit
  ];

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
