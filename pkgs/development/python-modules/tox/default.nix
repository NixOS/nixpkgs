{ lib
, buildPythonPackage
, fetchPypi
, packaging
, pluggy
, py
, six
, virtualenv
, setuptools-scm
, toml
, tomli
, filelock
, hatchling
, hatch-vcs
, platformdirs
, pyproject-api
, colorama
, chardet
, cachetools
, pythonOlder
}:

buildPythonPackage rec {
  pname = "tox";
  version = "4.0.16";
  format = "pyproject";

  buildInputs = [
    hatchling
    hatch-vcs
  ];
  propagatedBuildInputs = [
    cachetools
    chardet
    colorama
    filelock
    packaging
    platformdirs
    pluggy
    py
    pyproject-api
    six
    toml
    virtualenv
  ]
  ++ lib.optional
    (pythonOlder "3.11")
    tomli;

  doCheck = false;

  src = fetchPypi
    {
      inherit pname version;
      hash = "sha256-lo/E4nEQ3v3xWXKJPLFf4WafM4yECNiDUHdGL7B+B/4=";
    };

  meta = with lib; {
    description = "A generic virtualenv management and test command line tool";
    homepage = "https://tox.readthedocs.io/";
    license = licenses.mit;
  };
}
