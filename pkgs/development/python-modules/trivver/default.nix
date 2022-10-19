{ buildPythonPackage
, fetchFromGitLab
, lib
, ddt
, pytestCheckHook
, setuptools
}:

let
  trivver = buildPythonPackage rec {
    pname = "trivver";
    version = "2.2.2";
    format = "pyproject";

    src = fetchFromGitLab {
      owner = "ppentchev";
      repo = "python-trivver";
      rev = "release/${version}";
      sha256 = "Qh9tg7CCYLSfogYEJLpfBG0y3jF1jIjhD0Y0XvGo/VQ=";
    };

    meta = with lib; {
      homepage = "https://gitlab.com/ppentchev/python-trivver";
      description = " Compare package versions in all their varied glory";
      license = licenses.bsd2;
      maintainers = with maintainers; [ ppentchev ];
    };

    propagatedBuildInputs = [
      setuptools
    ];

    checkInputs = [
      ddt
      pytestCheckHook
    ];
    pythonImportsCheck = [ "trivver" ];
  };
in
trivver
