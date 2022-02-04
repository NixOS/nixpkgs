{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pytest-asyncio
, pretend
, freezegun
, twisted
, simplejson
, six
, pythonAtLeast
}:

buildPythonPackage rec {
  pname = "structlog";
  version = "21.4.0";
  format = "flit";

  # sdist is missing conftest.py
  src = fetchFromGitHub {
    owner = "hynek";
    repo = "structlog";
    rev = version;
    sha256 = "sha256-uXFSrC1TvQV46uu0sadC3eMq7yk5TnrpQE8m6NSv1Bg=";
  };

  checkInputs = [ pytestCheckHook pytest-asyncio pretend freezegun simplejson twisted ];
  propagatedBuildInputs = [ six ];

  meta = {
    description = "Painless structural logging";
    homepage = "https://github.com/hynek/structlog";
    license = lib.licenses.asl20;
  };
}
