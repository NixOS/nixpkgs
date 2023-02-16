{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy3k
, pytestCheckHook
, voluptuous
}:

buildPythonPackage rec  {
  pname = "voluptuous-serialize";
  version = "2.5.0";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = pname;
    rev = version;
    sha256 = "sha256-8rWMz8tBanxHdU/F4HhBxxz3ltqbdRoP4JED2dmZfTk=";
  };

  propagatedBuildInputs = [ voluptuous ];

  nativeCheckInputs = [
    pytestCheckHook
    voluptuous
  ];

  pythonImportsCheck = [ "voluptuous_serialize" ];

  meta = with lib; {
    homepage = "https://github.com/home-assistant-libs/voluptuous-serialize";
    license = licenses.asl20;
    description = "Convert Voluptuous schemas to dictionaries so they can be serialized";
    maintainers = with maintainers; [ ];
  };
}
