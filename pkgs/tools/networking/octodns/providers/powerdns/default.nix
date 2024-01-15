{ lib
, buildPythonPackage
, fetchFromGitHub
, octodns
, pytestCheckHook
, pythonOlder
, requests
, requests-mock
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "octodns-powerdns";
  version = "0.0.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "octodns";
    repo = "octodns-powerdns";
    rev = "v${version}";
    hash = "sha256-jt0+JnpCgvsoqMcC9mANX7uq2WPTiI2JQjwQi7LGWj0=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    octodns
    requests
  ];

  env.OCTODNS_RELEASE = 1;

  pythonImportsCheck = [ "octodns_powerdns" ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  meta = with lib; {
    description = "PowerDNS API provider for octoDNS";
    homepage = "https://github.com/octodns/octodns-powerdns/";
    changelog = "https://github.com/octodns/octodns-powerdns/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ janik ];
  };
}
