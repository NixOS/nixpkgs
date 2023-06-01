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
  version = "2.0";

  src = fetchPypi {
    inherit version;
    pname = "z3c.checkversions";
    hash = "sha256-rn4kl8Pn6YNqbE+VD6L8rVBQHkQqXSD47ZIy77+ashE=";
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
