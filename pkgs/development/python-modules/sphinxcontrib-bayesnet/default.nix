<<<<<<< HEAD
{ lib
, buildPythonPackage
, fetchPypi
, sphinx
, sphinxcontrib-tikz
}:
=======
{ stdenv, lib, buildPythonPackage, fetchPypi, sphinx, sphinxcontrib-tikz }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

buildPythonPackage rec {
  pname = "sphinxcontrib-bayesnet";
  version = "0.4";
<<<<<<< HEAD
  format = "setuptools";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+M+K8WzQqxQUGgAgGPK+isf3gKK7HOrdI6nNW/V8Wv0=";
  };

  propagatedBuildInputs = [ sphinx sphinxcontrib-tikz ];

  # No tests
  doCheck = false;
  pythonImportsCheck = [ "sphinxcontrib.bayesnet" ];

  meta = with lib; {
    homepage = "https://github.com/jluttine/sphinx-bayesnet";
    description = "Bayesian networks and factor graphs in Sphinx using TikZ syntax";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ jluttine ];
<<<<<<< HEAD
=======
    broken = true; # relies on 2to3 conversion, which was removed from setuptools>=58.0
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
