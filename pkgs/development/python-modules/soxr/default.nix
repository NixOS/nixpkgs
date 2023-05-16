{ lib
, buildPythonPackage
, fetchFromGitHub

<<<<<<< HEAD
# build-system
, cython_3
, numpy
, oldest-supported-numpy
=======
# build-sytem
, cython_3
, numpy
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, setuptools
, setuptools-scm
, gnutar

# native
, libsoxr

# tests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "soxr";
<<<<<<< HEAD
  version = "0.3.5";
=======
  version = "0.3.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "dofuuz";
    repo = "python-soxr";
    rev = "refs/tags/v${version}";
    fetchSubmodules = true;
<<<<<<< HEAD
    hash = "sha256-q/K7XlqvDHAna+fqN6iiJ9wD8efsuwHiEfKjXS46jz8=";
  };

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;
=======
    hash = "sha256-/NFGzOF1X9c0yccgtVNUO+1aIWoNdJqP/OKcNj+uKpk=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [
    cython_3
    gnutar
    numpy
<<<<<<< HEAD
    oldest-supported-numpy
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    setuptools
    setuptools-scm
  ];

  pythonImportsCheck = [
    "soxr"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "High quality, one-dimensional sample-rate conversion library";
    homepage = "https://github.com/dofuuz/python-soxr/tree/main";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ hexa ];
  };
}
