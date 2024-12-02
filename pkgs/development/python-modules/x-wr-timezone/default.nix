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
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "niccokunzmann";
    repo = "x-wr-timezone";
    rev = "refs/tags/v${version}";
    hash = "sha256-F/bNETgscbhEkpG/D1eSJaBNdpi0+xEYuNL4RURGST0=";
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
    changelog = "https://github.com/niccokunzmann/x-wr-timezone/blob/${src.rev}/README.rst#changelog";
    description = "Convert calendars using X-WR-TIMEZONE to standard ones";
    homepage = "https://github.com/niccokunzmann/x-wr-timezone";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
