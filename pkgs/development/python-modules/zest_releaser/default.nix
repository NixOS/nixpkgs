{ lib, buildPythonPackage, fetchFromGitHub
, setuptools, colorama, requests, six, twine
, z3c_testsetup, zope_testing, zope_testrunner, wheel, tox, check-manifest, pyroma
}:

buildPythonPackage rec {
  pname = "zest_releaser";
  version = "6.22.1";

  src = fetchFromGitHub {
    owner = "zestsoftware";
    repo = "zest.releaser";
    rev = version;
    sha256 = "005xmpwzkyg0q89vi485nhjjzi34yj2lpszigcph7y4p1bfzgiv4";
  };

  patchPhase = ''
    sed -i 's/py27,py35,py36,py37,py38,pypy,pypy3/py3/g' tox.ini

    sed -i 's/\[testenv\]/\[testenv\] \
    setenv   = \
    \tPYTHONPATH = {env:PYTHONPATH}{:}{toxinidir} \
    /g' tox.ini
  '';

  propagatedBuildInputs = [
    setuptools
    colorama
    requests
    six
    twine
  ];

  checkInputs = [
    z3c_testsetup
    zope_testing
    zope_testrunner
    wheel
    tox
    check-manifest
    pyroma
  ];
  checkPhase = ''
    tox
  '';
  doCheck = false;

  pythonImportsCheck = [ "zest.releaser" ];

  meta = with lib; {
    description = "A collection of command-line programs to help automating the task of releasing a Python project";
    downloadPage = "https://pypi.org/project/zest.releaser/";
    homepage = "https://github.com/zestsoftware/zest.releaser";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ superherointj ];
  };
}
