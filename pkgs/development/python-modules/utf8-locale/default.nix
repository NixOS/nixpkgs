{ buildPythonPackage
, fetchFromGitLab
, lib
, ddt
, pytestCheckHook
, setuptools
}:

let
  utf8-locale = buildPythonPackage rec {
    pname = "utf8-locale";
    version = "1.0.0";
    format = "pyproject";

    src = fetchFromGitLab {
      owner = "ppentchev";
      repo = "utf8-locale";
      rev = "release/${version}";
      sha256 = "VI9/8RMjFId6+IBz6ySZW0NFLVPSxcT0zzFDUkkRlng=";
    };

    meta = with lib; {
      homepage = "https://devel.ringlet.net/devel/utf8-locale/";
      description = "Detect a UTF-8-capable locale for running programs in";
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
    pythonImportsCheck = [ "utf8_locale" ];
  };
in
utf8-locale
