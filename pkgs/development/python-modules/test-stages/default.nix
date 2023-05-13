{ buildPythonPackage
, fetchFromGitLab
, lib
, pytestCheckHook

, hatchling
, hatch-requirements-txt

, click
, distlib
, parse-stages
, pyparsing
, utf8-locale

, contextlib-chdir
, tox
}:

let
  test-stages = buildPythonPackage rec {
    pname = "test-stages";
    version = "0.1.2";
    format = "pyproject";

    src = fetchFromGitLab {
      owner = "ppentchev";
      repo = "test-stages";
      rev = "release/${version}";
      sha256 = "9EvDJRFu/9pRqT2tdjA0RP2W8BAZt6Yc+V1FjvPmov4=";
    };

    meta = with lib; {
      homepage = "https://devel.ringlet.net/devel/test-stages/";
      description = "Group Tox, Nox, etc environments into stages, run them in parallel";
      license = licenses.bsd2;
      maintainers = with maintainers; [ ppentchev ];
    };

    propagatedBuildInputs = [
      hatchling
      hatch-requirements-txt

      click
      distlib
      parse-stages
      pyparsing
      utf8-locale

      contextlib-chdir
      tox
    ];

    checkInputs = [
      pytestCheckHook
    ];
    pythonImportsCheck = [
      "test_stages"
      "test_stages.tox_stages.__main__"
      "tox_trivtags"
    ];
  };
in
test-stages
