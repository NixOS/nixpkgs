{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pytest-asyncio
, pretend
, freezegun
, simplejson
, six
, pythonAtLeast
}:

buildPythonPackage rec {
  pname = "structlog";
  version = "22.1.0";
  format = "flit";

  src = fetchFromGitHub {
    owner = "hynek";
    repo = "structlog";
    rev = "refs/tags/${version}";
    sha256 = "sha256-2sdH6iP+l+6pBNC+sjpAX8bCdCANqqkaqZRmR68uwxY=";
  };

  propagatedBuildInputs = [ six ];

  checkInputs = [ pytestCheckHook pytest-asyncio pretend freezegun simplejson ];

  meta = with lib; {
    description = "Painless structural logging";
    homepage = "https://github.com/hynek/structlog";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
