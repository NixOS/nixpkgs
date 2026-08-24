{
  lib,
  buildPythonPackage,
  fetchPypi,
  pypaInstallHook,
  setuptoolsBuildHook,
}:

buildPythonPackage rec {
  pname = "text2digits";
  version = "0.1.2";
  pyproject = false;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AgUwIIGcuzAkjz1xo+snRZ9JB9IwDCICNb8P4HSaerA=";
  };

  nativeBuildInputs = [
    pypaInstallHook
    setuptoolsBuildHook
  ];

  pythonImportsCheck = [ "text2digits" ];

  meta = {
    description = "Converts text such as 'twenty three' to number/digit '23' in any sentence";
    homepage = "https://github.com/ShailChoksi/text2digits";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ getchoo ];
  };
}
