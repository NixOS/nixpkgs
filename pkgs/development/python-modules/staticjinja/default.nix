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
, testVersion
, tomlkit
, staticjinja
, callPackage
}:

buildPythonPackage rec {
  pname = "staticjinja";
  version = "4.1.2";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  # No tests in pypi
  src = fetchFromGitHub {
    owner = "staticjinja";
    repo = pname;
    rev = version;
    sha256 = "sha256-YHhGohA24D4O/Bj7JZTj8qaEGEZAupvxWcZYjWFTHmM=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    jinja2
    docopt-ng
    easywatch
  ];

  checkInputs = [
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
    version = testVersion { package = staticjinja; };
    minimal-template = callPackage ./test-minimal-template {};
  };

  meta = with lib; {
    description = "A library and cli tool that makes it easy to build static sites using Jinja2";
    homepage = "https://staticjinja.readthedocs.io/en/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz ];
  };
}
