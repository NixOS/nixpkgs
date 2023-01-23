{ lib
, buildPythonPackage
, fetchFromGitHub
, icalendar
, pytz
, pytestCheckHook
, restructuredtext_lint
, pygments
}:

buildPythonPackage rec {
  pname = "x-wr-timezone";
  version = "0.0.5";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "niccokunzmann";
    repo = "x-wr-timezone";
    rev = "v${version}";
    hash = "sha256-vUhAq6b5I0gYbXmbElxSSL6Mu9BSLs0uT5gb8zXdmpg=";
  };

  propagatedBuildInputs = [
    icalendar
    pytz
  ];

  nativeCheckInputs = [
    pytestCheckHook
    restructuredtext_lint
    pygments
  ];

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  pythonImportsCheck = [ "x_wr_timezone" ];

  meta = {
    description = "Convert calendars using X-WR-TIMEZONE to standard ones";
    homepage = "https://github.com/niccokunzmann/x-wr-timezone";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
