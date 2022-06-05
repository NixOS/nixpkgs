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
  version = "21.5.0";
  format = "flit";

  src = fetchFromGitHub {
    owner = "hynek";
    repo = "structlog";
    rev = version;
    sha256 = "0bc5lj0732j0hjq89llgrncyzs6k3aaffvg07kr3la44w0hlrb4l";
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
