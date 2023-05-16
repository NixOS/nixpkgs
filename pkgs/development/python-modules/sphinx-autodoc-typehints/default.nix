{ lib
, buildPythonPackage
, fetchPypi
, hatch-vcs
, hatchling
, pythonOlder
, sphinx
, pytestCheckHook
}:

let
  pname = "sphinx-autodoc-typehints";
<<<<<<< HEAD
  version = "1.23.0";
=======
  version = "1.22";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
in

buildPythonPackage {
  inherit pname version;
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "sphinx_autodoc_typehints";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-XUTimWYzza2kmbbSeklt3528ld0fDwn3s3lAJJ5h9uk=";
=======
    hash = "sha256-cfyi1e7psDQgTkxoarILTY9euUCTliFryubIfDjhjqY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  propagatedBuildInputs = [
    sphinx
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # requires spobjinv, nbtyping
  doCheck = false;

  pythonImportsCheck = [
    "sphinx_autodoc_typehints"
  ];

  meta = with lib; {
    changelog = "https://github.com/tox-dev/sphinx-autodoc-typehints/releases/tag/${version}";
    description = "Type hints (PEP 484) support for the Sphinx autodoc extension";
    homepage = "https://github.com/tox-dev/sphinx-autodoc-typehints";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
