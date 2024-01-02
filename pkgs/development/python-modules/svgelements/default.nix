{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, wheel
, anyio
, numpy
, pillow
, pytest-forked
, pytest-xdist
, pytestCheckHook
, scipy
}:

buildPythonPackage rec {
  pname = "svgelements";
  version = "1.9.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "meerk40t";
    repo = "svgelements";
    rev = "refs/tags/${version}";
    hash = "sha256-nx2sGXeeh8S17TfRDFifQbdSxc4YGsDNnrPSSbxv7S4=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [ "svgelements" ];

  nativeCheckInputs =  [
    anyio
    numpy
    pillow
    pytest-forked
    pytest-xdist
    pytestCheckHook
    scipy
  ];

  meta = with lib; {
    description = "SVG Parsing for Elements, Paths, and other SVG Objects";
    homepage = "https://github.com/meerk40t/svgelements";
    license = licenses.mit;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
