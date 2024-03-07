{ lib
, buildPythonPackage
, fetchFromGitHub
, octodns
, pytestCheckHook
, pythonOlder
, dnspython
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "octodns-bind";
  version = "0.0.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "octodns";
    repo = "octodns-bind";
    rev = "v${version}";
    hash = "sha256-0ia/xYarrOiLZa8KU0s5wtCGtXIyxSl6OcwNkSJb/rA=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    octodns
    dnspython
  ];

  env.OCTODNS_RELEASE = 1;

  pythonImportsCheck = [ "octodns_bind" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = " RFC compliant (Bind9) provider for octoDNS";
    homepage = "https://github.com/octodns/octodns-bind";
    changelog = "https://github.com/octodns/octodns-bind/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ janik ];
  };
}
