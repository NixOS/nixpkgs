{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  colorama,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "simber";
  version = "0.2.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "deepjyoti30";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-kHoFZD7nhVxJu9MqePLkL7KTG2saPecY9238c/oeEco=";
  };

  propagatedBuildInputs = [ colorama ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "simber" ];

  meta = with lib; {
    description = "Simple, minimal and powerful logger for Python";
    homepage = "https://github.com/deepjyoti30/simber";
    changelog = "https://github.com/deepjyoti30/simber/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ j0hax ];
  };
}
