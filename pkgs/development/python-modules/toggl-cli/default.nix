{ lib
, buildPythonPackage
, click
, click-completion
, factory-boy
, faker
, fetchPypi
, inquirer
, notify-py
, pbr
, pendulum
, ptable
, pytest-mock
, pytestCheckHook
, pythonOlder
, requests
, twine
, validate-email
}:

buildPythonPackage rec {
  pname = "toggl-cli";
  version = "2.4.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "togglCli";
    inherit version;
    hash = "sha256-ncMwiMwYivaFu5jrAsm1oCuXP/PZ2ALT+M+CmV6dtFo=";
  };

  nativeBuildInputs = [
    pbr
    twine
  ];

  propagatedBuildInputs = [
    click
    click-completion
    inquirer
    notify-py
    pbr
    pendulum
    ptable
    requests
    validate-email
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
    faker
    factory-boy
  ];

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "notify-py==0.3.3" "notify-py>=0.3.3" \
      --replace "click==8.0.3" "click>=8.0.3" \
      --replace "pbr==5.8.0" "pbr>=5.8.0" \
      --replace "inquirer==2.9.1" "inquirer>=2.9.1"
    substituteInPlace pytest.ini \
      --replace ' --cov toggl -m "not premium"' ""
  '';

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

  pythonImportsCheck = [
    "toggl"
  ];

  # updates to a bogus tag
  passthru.skipBulkUpdate = true;

  meta = with lib; {
    description = "Command line tool and set of Python wrapper classes for interacting with toggl's API";
    homepage = "https://toggl.uhlir.dev/";
    license = licenses.mit;
    maintainers = with maintainers; [ mmahut ];
  };
}
