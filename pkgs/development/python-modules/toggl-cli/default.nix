{ lib, buildPythonPackage, fetchPypi, pythonAtLeast, pythonOlder, click
, click-completion, factory_boy, faker, inquirer, notify-py, pbr, pendulum
, ptable, pytestCheckHook, pytest-cov, pytest-mock, requests, twine
, validate-email }:

buildPythonPackage rec {
  pname = "toggl-cli";
  version = "2.4.2";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    pname = "togglCli";
    inherit version;
    sha256 = "1wgh231r16jyvaj1ch1pajvl9szflb4srs505pfdwdlqvz7rzww8";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "notify-py==0.3.1" "notify-py>=0.3.1"
  '';

  nativeBuildInputs = [ pbr twine ];
  checkInputs = [ pbr pytestCheckHook pytest-cov pytest-mock faker factory_boy ];

  preCheck = ''
    export TOGGL_API_TOKEN=your_api_token
    export TOGGL_PASSWORD=toggl_password
    export TOGGL_USERNAME=user@example.com
  '';

  disabledTests = [
    "integration"
    "premium"
    "test_parsing"
    "test_type_check"
    "test_now"
  ];

  propagatedBuildInputs = [
    click
    click-completion
    inquirer
    notify-py
    pendulum
    ptable
    requests
    pbr
    validate-email
  ];

  meta = with lib; {
    homepage = "https://toggl.uhlir.dev/";
    description = "Command line tool and set of Python wrapper classes for interacting with toggl's API";
    license = licenses.mit;
    maintainers = [ maintainers.mmahut ];
  };
}
