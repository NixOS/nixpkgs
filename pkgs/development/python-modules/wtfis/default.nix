{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, hatchling
, pydantic
, requests
, rich
, rich-rst
, pytest-mock
, pytestCheckHook
, shodan
}:

buildPythonPackage rec {
  pname = "wtfis";
  version = "0.2.2";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "pirxthepilot";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-LgN0t+6peT1x8/wC+gzlhj4tyFAe753aC0xAICvi7yg=";
  };

  propagatedBuildInputs = [
    hatchling
    pydantic
    requests
    rich
    shodan
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '"rich~=12.5.1",' ""
  '';


  meta = with lib; {
    description = "Passive host and domain name lookup tool for non-robots";
    homepage = "https://github.com/pirxthepilot/wtfis";
    license = licenses.mit;
    maintainers = with maintainers; [ techknowlogick ];
  };
}
