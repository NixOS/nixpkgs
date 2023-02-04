{ lib
, fetchFromGitHub
, buildPythonPackage
, poetry-core
, docopt-ng
, easywatch
, jinja2
, pytestCheckHook
, pytest-check
, pythonOlder
, markdown
, testers
, tomlkit
, staticjinja
, callPackage
}:

buildPythonPackage rec {
  pname = "staticjinja";
  version = "4.1.3";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  # No tests in pypi
  src = fetchFromGitHub {
    owner = "staticjinja";
    repo = pname;
    rev = version;
    sha256 = "sha256-w6ge5MQXNRHCM43jKnagTlbquJJys7mprgBOS2uuwHQ=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    jinja2
    docopt-ng
    easywatch
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-check
    markdown
    tomlkit
  ];

  # The tests need to find and call the installed staticjinja executable
  preCheck = ''
    export PATH="$PATH:$out/bin";
  '';

  passthru.tests = {
    version = testers.testVersion { package = staticjinja; };
    minimal-template = callPackage ./test-minimal-template {};
  };

  meta = with lib; {
    description = "A library and cli tool that makes it easy to build static sites using Jinja2";
    homepage = "https://staticjinja.readthedocs.io/en/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz ];
  };
}
