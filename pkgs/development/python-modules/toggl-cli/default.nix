{ stdenv, buildPythonPackage, fetchPypi, pythonAtLeast, pythonOlder
, click
, click-completion
, factory_boy
, faker
, inquirer
, notify-py
, pbr
, pendulum
, ptable
, pytest
, pytestcov
, pytest-mock
, requests
, twine
, validate-email
}:


buildPythonPackage rec {
  pname = "toggl-cli";
  version = "2.2.1";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    pname = "togglCli";
    inherit version;
    sha256 = "1izsxag98lvivkwf7724g2ak6icjak9jdqphaq1a79kwdnqprx1m";
  };

  postPatch = ''
   substituteInPlace requirements.txt \
     --replace "inquirer==2.6.3" "inquirer>=2.6.3" \
     --replace "notify-py==0.2.2" "notify-py>=0.2.2"
  '';

  nativeBuildInputs = [ pbr twine ];
  checkInputs = [ pbr pytest pytestcov pytest-mock faker factory_boy ];

  preCheck = ''
    export TOGGL_API_TOKEN=your_api_token
    export TOGGL_PASSWORD=toggl_password
    export TOGGL_USERNAME=user@example.com
    '';

  checkPhase = ''
   runHook preCheck
   pytest -k "not premium and not TestDateTimeType and not TestDateTimeField" tests/unit --maxfail=20
   runHook postCheck
  '';

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

  meta = with stdenv.lib; {
    homepage = "https://toggl.uhlir.dev/";
    description = "Command line tool and set of Python wrapper classes for interacting with toggl's API";
    license = licenses.mit;
    maintainers = [ maintainers.mmahut ];
  };
}
