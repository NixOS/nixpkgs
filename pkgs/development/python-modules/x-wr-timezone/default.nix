{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  click,
  icalendar,
  tzdata,
  pytestCheckHook,
  restructuredtext-lint,
  pygments,
  pytz,
  pytest-click,
}:

buildPythonPackage rec {
  pname = "x-wr-timezone";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "niccokunzmann";
    repo = "x-wr-timezone";
    tag = "v${version}";
    hash = "sha256-Llpe3Z0Yfd0vRgx95D4YVrnNJk0g/VqPuNvtUrUpFk0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
    icalendar
    tzdata
  ];

  nativeCheckInputs = [
    pytestCheckHook
    restructuredtext-lint
    pygments
    pytz
    pytest-click
  ];

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  pythonImportsCheck = [ "x_wr_timezone" ];

  meta = {
    changelog = "https://github.com/niccokunzmann/x-wr-timezone/blob/${src.tag}/README.rst#changelog";
    description = "Convert calendars using X-WR-TIMEZONE to standard ones";
    homepage = "https://github.com/niccokunzmann/x-wr-timezone";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
