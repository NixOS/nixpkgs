{ lib
, buildPythonPackage
, pythonOlder
, fetchFromBitbucket
, ziafont
, pytestCheckHook
, nbval
, latex2mathml
}:

buildPythonPackage rec {
  pname = "ziamath";
  version = "0.7";

  disabled = pythonOlder "3.8";

  src = fetchFromBitbucket {
    owner = "cdelker";
    repo = pname;
    rev = version;
    hash = "sha256-JuuCDww0EZEHZLxB5oQrWEJpv0szjwe4iXCRGl7OYTA=";
  };

  propagatedBuildInputs = [
    ziafont
  ];

  nativeCheckInputs = [
    pytestCheckHook
    nbval
    latex2mathml
  ];

  pytestFlagsArray = [ "--nbval-lax" ];

  pythonImportsCheck = [ "ziamath" ];

  meta = with lib; {
    description = "Render MathML and LaTeX Math to SVG without Latex installation";
    homepage = "https://ziamath.readthedocs.io/en/latest/";
    changelog = "https://ziamath.readthedocs.io/en/latest/changes.html";
    license = licenses.mit;
    maintainers = with maintainers; [ sfrijters ];
  };
}
