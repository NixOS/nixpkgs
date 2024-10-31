{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  icalendar,
  tzdata,
  pytestCheckHook,
  restructuredtext-lint,
  pygments,
  pytz,
}:

buildPythonPackage rec {
  pname = "x-wr-timezone";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "niccokunzmann";
    repo = "x-wr-timezone";
    rev = "v${version}";
    hash = "sha256-MDFniFhgRuNtYITH/IUUP/HHC79coqxgXrlErj+Yrcs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    icalendar
    tzdata
  ];

  nativeCheckInputs = [
    pytestCheckHook
    restructuredtext-lint
    pygments
    pytz
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
