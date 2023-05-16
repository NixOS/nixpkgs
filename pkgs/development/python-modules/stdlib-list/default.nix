{ lib
, buildPythonPackage
<<<<<<< HEAD
, fetchPypi

# build-system
, flit-core
=======
, isPy27
, fetchPypi
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "stdlib-list";
<<<<<<< HEAD
  version = "0.9.0";
  format = "pyproject";

  src = fetchPypi {
    pname = "stdlib_list";
    inherit version;
    hash = "sha256-mOtmE1l2yWtO4/TA7wVS67Wpl3zjAoQz23n0c4sCryY=";
  };

  nativeBuildInputs = [
    flit-core
  ];

=======
  version = "0.8.0";
  format = "setuptools";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "17vdn4q0sdlndc2fr9svapxx6366hnrhkn0fswp1xmr0jxqh7rd1";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pythonImportsCheck = [
    "stdlib_list"
  ];

  # tests see mismatches to our standard library
  doCheck = false;

  meta = with lib; {
<<<<<<< HEAD
    changelog = "https://github.com/pypi/stdlib-list/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "A list of Python Standard Libraries";
    homepage = "https://github.com/jackmaney/python-stdlib-list";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
