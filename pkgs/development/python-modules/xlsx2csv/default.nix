{ lib
, buildPythonPackage
, fetchPypi
, setuptools
<<<<<<< HEAD
, setuptools-scm
, wheel
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "xlsx2csv";
  version = "0.8.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fs1tK8JCby5DL0/awSIR4ZdtPLtl+QM+Htpl7dogReM=";
  };

  nativeBuildInputs = [
    setuptools
<<<<<<< HEAD
    setuptools-scm
    wheel
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  meta = with lib; {
    homepage = "https://github.com/dilshod/xlsx2csv";
    description = "Convert xlsx to csv";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jb55 ];
  };
}
