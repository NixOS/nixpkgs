{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, python
, zc-buildout
, zope_testrunner
}:

buildPythonPackage rec {
  pname = "z3c-checkversions";
<<<<<<< HEAD
  version = "2.1";
=======
  version = "2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchPypi {
    inherit version;
    pname = "z3c.checkversions";
<<<<<<< HEAD
    hash = "sha256-j5So40SyJf7XfCz3P9YFR/6z94up3LY2/dfEmmIbxAk=";
=======
    hash = "sha256-rn4kl8Pn6YNqbE+VD6L8rVBQHkQqXSD47ZIy77+ashE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [ zc-buildout ];

  nativeCheckInputs = [ zope_testrunner ];

  checkPhase = ''
    ${python.interpreter} -m zope.testrunner --test-path=src []
  '';

  meta = with lib; {
    homepage = "https://github.com/zopefoundation/z3c.checkversions";
    changelog = "https://github.com/zopefoundation/z3c.checkversions/blob/${version}/CHANGES.rst";
    description = "Find newer package versions on PyPI";
    license = licenses.zpl21;
  };
}
