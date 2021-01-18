{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy3k
, pytestCheckHook
, voluptuous
}:

buildPythonPackage rec  {
  pname = "voluptuous-serialize";
  version = "2.4.0";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = pname;
    rev = version;
    sha256 = "1km2y1xaagkdvsy3bmi1sc040x5yyfdw6llmwdv9z8nz67m9v1ya";
  };

  propagatedBuildInputs = [ voluptuous ];

  checkInputs = [
    pytestCheckHook
    voluptuous
  ];

  pythonImportsCheck = [ "voluptuous_serialize" ];

  meta = with lib; {
    homepage = "https://github.com/home-assistant-libs/voluptuous-serialize";
    license = licenses.asl20;
    description = "Convert Voluptuous schemas to dictionaries so they can be serialized";
    maintainers = with maintainers; [ etu ];
  };
}
