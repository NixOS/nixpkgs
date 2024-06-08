{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  icalendar,
  pytz,
  pytestCheckHook,
  restructuredtext-lint,
  pygments,
}:

buildPythonPackage rec {
  pname = "x-wr-timezone";
  version = "0.0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "niccokunzmann";
    repo = "x-wr-timezone";
    rev = "v${version}";
    hash = "sha256-itqsVYYUcpbKTh0BM6IHk6F9xhB+pAQnnJsnZAVpNL4=";
  };

  nativeBuildInputs = [ setuptools ];

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

  disabledTests = [
    "test_input_to_output"
    "test_output_stays_the_same"
  ];

  pythonImportsCheck = [ "x_wr_timezone" ];

  meta = {
    changelog = "https://github.com/niccokunzmann/x-wr-timezone/blob/${src.rev}/README.rst#changelog";
    description = "Convert calendars using X-WR-TIMEZONE to standard ones";
    homepage = "https://github.com/niccokunzmann/x-wr-timezone";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
