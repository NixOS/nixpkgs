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
  version = "0.9.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "203c1c6ec73dd1eb0fecd4981b31f8e05042f0dda16443190ac9ade1113ff53d";
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
