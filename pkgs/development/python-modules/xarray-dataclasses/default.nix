{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, poetry-core
, pytestCheckHook
, numpy
, typing-extensions
, xarray
}:

buildPythonPackage rec {
  pname = "xarray-dataclasses";
  version = "1.7.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "astropenguin";
    repo = "xarray-dataclasses";
    rev = "refs/tags/v${version}";
    hash = "sha256-fyRUH6t2+9tsxRQFfJR2EHinYtwCmWeCB77kpmBgdBA=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    numpy
    typing-extensions
    xarray
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "xarray_dataclasses" ];

  meta = with lib; {
    description = "xarray data creation made easy by dataclass";
    homepage = "https://github.com/astropenguin/xarray-dataclasses";
    changelog = "https://github.com/astropenguin/xarray-dataclasses/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
