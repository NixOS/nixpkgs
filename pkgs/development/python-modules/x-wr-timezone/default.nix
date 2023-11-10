{ lib
, buildPythonPackage
, fetchFromGitHub
, icalendar
, pytz
, pytestCheckHook
, restructuredtext-lint
, pygments
}:

buildPythonPackage rec {
  pname = "x-wr-timezone";
  version = "0.0.6";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "niccokunzmann";
    repo = "x-wr-timezone";
    rev = "v${version}";
    hash = "sha256-9B1gXabpZsJSHYUHLu6bBGidO3C5m/I0oOc5U/mbX0I=";
  };

  propagatedBuildInputs = [
    icalendar
    pytz
  ];

  nativeCheckInputs = [
    pytestCheckHook
    restructuredtext-lint
    pygments
  ];

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  # https://github.com/niccokunzmann/x-wr-timezone/issues/8
  doCheck = false;

  pythonImportsCheck = [ "x_wr_timezone" ];

  meta = {
    changelog = "https://github.com/niccokunzmann/x-wr-timezone/blob/${src.rev}/README.rst#changelog";
    description = "Convert calendars using X-WR-TIMEZONE to standard ones";
    homepage = "https://github.com/niccokunzmann/x-wr-timezone";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
