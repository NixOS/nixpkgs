{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  colorama,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "simber";
  version = "0.2.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "deepjyoti30";
    repo = "simber";
    tag = version;
    hash = "sha256-kHoFZD7nhVxJu9MqePLkL7KTG2saPecY9238c/oeEco=";
  };

  propagatedBuildInputs = [ colorama ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "simber" ];

  meta = {
    description = "Simple, minimal and powerful logger for Python";
    homepage = "https://github.com/deepjyoti30/simber";
    changelog = "https://github.com/deepjyoti30/simber/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ j0hax ];
  };
}
