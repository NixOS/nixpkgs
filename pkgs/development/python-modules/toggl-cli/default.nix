{ stdenv, buildPythonPackage, fetchPypi, twine, pbr, click, click-completion, validate-email,
pendulum, ptable, requests, inquirer, pythonOlder, pytest, pytestcov, pytest-mock, faker, factory_boy,
setuptools }:


buildPythonPackage rec {
  pname = "toggl-cli";
  version = "2.1.0";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    pname = "togglCli";
    inherit version;
    sha256 = "0iirvvb8772569v28d36bnryksm1qkkw48d48fw26j7ka01qq6mm";
  };

  postPatch = ''
   substituteInPlace requirements.txt \
     --replace "pendulum==2.0.4" "pendulum>=2.0.4" \
     --replace "click-completion==0.5.0" "click-completion>=0.5.0" \
     --replace "pbr==5.1.2" "pbr>=5.1.2" \
     --replace "inquirer==2.5.1" "inquirer>=2.5.1"
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
    setuptools
    click
    click-completion
    validate-email
    pendulum
    ptable
    requests
    inquirer
    pbr
  ];

  meta = with stdenv.lib; {
    homepage = "https://toggl.uhlir.dev/";
    description = "Command line tool and set of Python wrapper classes for interacting with toggl's API";
    license = licenses.mit;
    maintainers = [ maintainers.mmahut ];
  };
}

