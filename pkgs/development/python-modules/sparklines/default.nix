{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  future,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "sparklines";
  version = "0.5.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "deeplook";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-oit1bDqP96wwfTRCV8V0N9P/+pkdW2WYOWT6u3lb4Xs=";
  };

  propagatedBuildInputs = [ future ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "sparklines" ];

  meta = with lib; {
    description = "This Python package implements Edward Tufte's concept of sparklines, but limited to text only";
    mainProgram = "sparklines";
    homepage = "https://github.com/deeplook/sparklines";
    maintainers = with maintainers; [ rhoriguchi ];
    license = licenses.gpl3Only;
  };
}
