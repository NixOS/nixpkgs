{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
  certifi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "twitter";
  version = "1.19.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gN3WmuLuuIMT/u3uoxvxGf1ueVQe5bN6u5xD0jMZThA=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ certifi ];

  doCheck = false;

  pythonImportsCheck = [ "twitter" ];

  meta = with lib; {
    description = "Twitter API library";
    homepage = "https://mike.verdone.ca/twitter/";
    license = licenses.mit;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
