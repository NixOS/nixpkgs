{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, icalendar
, pytz
, restructuredtext_lint
, pygments
}:

buildPythonPackage rec {
  pname = "x-wr-timezone";
  version = "0.0.5";

  src = fetchFromGitHub {
    owner = "niccokunzmann";
    repo = "x-wr-timezone";
    rev = "v${version}";
    sha256 = "164svlsz66wq9wpcsbjjs2xqrgj8a9f156vrdlc4h8zrlsml0j5x";
  };

  propagatedBuildInputs = [
    icalendar
    pytz
  ];

  pythonImportsCheck = [ "x_wr_timezone" ];

  checkInputs = [
    pytestCheckHook
    restructuredtext_lint
    pygments
  ];

  disabledTestPaths = [
    "test/test_command_line.py"
  ];

  meta = {
    description = "Handling of non-standard X-WR-TIMEZONE icalendar property in Python and Command Line";
    homepage = "https://github.com/niccokunzmann/x-wr-timezone";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ swflint ];
  };

}
