{
  lib,
  buildPythonPackage,
  click,
  click-completion,
  factory-boy,
  faker,
  fetchPypi,
  inquirer,
  notify-py,
  pbr,
  pendulum,
  prettytable,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  requests,
  setuptools,
  twine,
  validate-email,
}:

buildPythonPackage rec {
  pname = "toggl-cli";
  version = "2.4.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "togglCli";
    inherit version;
    hash = "sha256-P4pv6LMPIWXD04IQw01yo3z3voeV4OmsBOCSJgcrZ6g=";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace-fail "==" ">="
    substituteInPlace pytest.ini \
      --replace ' --cov toggl -m "not premium"' ""
  '';

  build-system = [
    pbr
    setuptools
    twine
  ];

  dependencies = [
    click
    click-completion
    inquirer
    notify-py
    pbr
    pendulum
    prettytable
    requests
    validate-email
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
    faker
    factory-boy
  ];

  preCheck = ''
    export TOGGL_API_TOKEN=your_api_token
    export TOGGL_PASSWORD=toggl_password
    export TOGGL_USERNAME=user@example.com
  '';

  disabledTests = [
    "integration"
    "premium"
    "test_basic_usage"
    "test_now"
    "test_parsing"
    "test_type_check"
  ];

  pythonImportsCheck = [ "toggl" ];

  # updates to a bogus tag
  passthru.skipBulkUpdate = true;

  meta = with lib; {
    description = "Command line tool and set of Python wrapper classes for interacting with toggl's API";
    homepage = "https://toggl.uhlir.dev/";
    license = licenses.mit;
    maintainers = with maintainers; [ mmahut ];
    mainProgram = "toggl";
  };
}
