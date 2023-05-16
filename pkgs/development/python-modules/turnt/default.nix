{ lib, buildPythonPackage, fetchPypi, click, tomli }:

buildPythonPackage rec {
  pname = "turnt";
<<<<<<< HEAD
  version = "1.11.0";
=======
  version = "1.10.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "flit";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-XN+qzRgZMSdeBmW0OM36mQ79sRCuP8E++SqH8FOoEq0=";
=======
    hash = "sha256-pwUNmUvyUYxke39orGkziL3DVRWoJY5AQLz/pTyf3M8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
