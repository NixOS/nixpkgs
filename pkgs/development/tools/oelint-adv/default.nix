{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pythonRelaxDepsHook
, anytree
, colorama
, oelint-parser
, urllib3
, pytestCheckHook
, pytest-cov
, pytest-forked
, pytest-random-order
, pytest-socket
, pytest-sugar
}:

buildPythonPackage rec {
  pname = "oelint-adv";
  version = "3.21.4";

  src = fetchFromGitHub {
    owner = "priv-kweihmann";
    repo = pname;
    rev = version;
    hash = "sha256-OAvL0VZXAXYp4RvNzPtMHMU5AkQLj6tu/My270BaMTM=";
  };

  disabled = pythonOlder "3.7";

  nativeBuildInputs = [ pythonRelaxDepsHook ];
  pythonRelaxDeps = true;

  propagatedBuildInputs = [ anytree colorama oelint-parser urllib3 ];

  checkInputs = [
    pytest-cov
    pytest-forked
    pytest-random-order
    pytest-socket
    pytest-sugar
    pytestCheckHook
  ];

  pytestFlagsArray = [ "--cov-fail-under=30" ];
  disabledTests = [ "oelint.vars.homepageping" ];

  meta = with lib; {
    description = "Advanced linter for BitBake recipes based on oelint";
    homepage = "https://github.com/priv-kweihmann/oelint-adv";
    changelog = "https://github.com/priv-kweihmann/oelint-adv/releases/tag/${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ christoph-heiss ];
  };
}
