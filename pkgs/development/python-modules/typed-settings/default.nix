{ lib
, buildPythonPackage
, fetchPypi
, setuptoolsBuildHook
, attrs
, toml
, pytestCheckHook
, click
}:

buildPythonPackage rec {
  pname = "typed-settings";
  version = "0.10.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fr6qkq3ldlp5i5l4b891w9ail9lfhaxlar3yij912slq5w0s8aw";
  };

  nativeBuildInputs = [
    setuptoolsBuildHook
    pytestCheckHook
  ];

  propagatedBuildInputs = [
    attrs
    toml
  ];

  checkInputs = [
    click
  ];

  meta = {
    description = "Typed settings based on attrs classes";
    homepage = "https://gitlab.com/sscherfke/typed-settings";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
