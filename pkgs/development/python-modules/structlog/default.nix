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
  version = "21.5.0";
  format = "flit";

  # sdist is missing conftest.py
  src = fetchFromGitHub {
    owner = "hynek";
    repo = "structlog";
    rev = version;
    sha256 = "0bc5lj0732j0hjq89llgrncyzs6k3aaffvg07kr3la44w0hlrb4l";
  };

  checkInputs = [ pytestCheckHook pytest-asyncio pretend freezegun simplejson twisted ];
  propagatedBuildInputs = [ six ];

  meta = {
    description = "Painless structural logging";
    homepage = "https://github.com/hynek/structlog";
    license = lib.licenses.asl20;
  };
}
