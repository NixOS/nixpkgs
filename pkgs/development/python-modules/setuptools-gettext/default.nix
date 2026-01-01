{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
<<<<<<< HEAD
  gettext,
  pytestCheckHook,
  setuptools,
=======
  pythonOlder,
  setuptools,
  tomli,
  pytestCheckHook,
  gettext,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "setuptools-gettext";
<<<<<<< HEAD
  version = "0.1.16";
  pyproject = true;

=======
  version = "0.1.14";
  pyproject = true;

  disabled = pythonOlder "3.8";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "breezy-team";
    repo = "setuptools-gettext";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-N59Hx6CyOzAin8KcMTAD++HFLDdJnJbql/U3fO2F3DU=";
=======
    hash = "sha256-05xKWRxmoI8tnRENuiK3Z3WNMyjgXIX5p3vhzSUeytQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

<<<<<<< HEAD
  dependencies = [ setuptools ];
=======
  dependencies = [ setuptools ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  pythonImportsCheck = [ "setuptools_gettext" ];

  nativeCheckInputs = [
    pytestCheckHook
    gettext
  ];

  meta = {
<<<<<<< HEAD
    changelog = "https://github.com/breezy-team/setuptools-gettext/releases/tag/${src.tag}";
=======
    changelog = "https://github.com/breezy-team/setuptools-gettext/releases/tag/v${version}";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Setuptools plugin for building mo files";
    homepage = "https://github.com/breezy-team/setuptools-gettext";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
