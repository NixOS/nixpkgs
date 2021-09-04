{ lib, buildPythonPackage, fetchPypi
, webob, six
, zope_bobodoctestumentation, setuptools, zc_buildout, flake8, check-manifest, check-python-versions, coverage, coverage-python-version, zope_testrunner
}:

buildPythonPackage rec {
  pname = "zope_bobo";
  version = "2.4.0";

  src = fetchPypi {
    pname = "bobo";
    inherit version;
    sha256 = "993711b05f4db31829fb85288be95d8d75228fa48987bda812ab54219490e3b3";
  };

  propagatedBuildInputs = [
    webob
    six
  ];

  checkInputs = [
    zope_bobodoctestumentation
    setuptools
    (zc_buildout.overridePythonAttrs (oldAttrs: rec { doCheck = false; }))
    flake8
    check-manifest
    check-python-versions
    coverage
    coverage-python-version
    zope_testrunner
  ];
  checkPhase = ''
    runHook preCheck
    zope-testrunner --test-path=src
    runHook postCheck
  '';

  pythonImportsCheck = [ "bobo" "boboserver" ];

  meta = with lib; {
    description = "A light-weight framework for creating WSGI web applications.";
    longDescription = "Provides mapping URLs to objects and calling objects to generate HTTP responses.";
    downloadPage = "https://pypi.org/project/bobo/";
    homepage = "https://github.com/zopefoundation/bobo/";
    license = licenses.zpl21;
    maintainers = with maintainers; [ superherointj ];
  };
}
