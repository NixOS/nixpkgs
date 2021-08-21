{ lib
, fetchFromGitHub
, buildPythonPackage
, poetry
, docopt-ng
, easywatch
, jinja2
, pytestCheckHook
, pytest-check
, markdown
, testVersion
, staticjinja
}:

buildPythonPackage rec {
  pname = "staticjinja";
  version = "4.1.0";
  format = "pyproject";

  # No tests in pypi
  src = fetchFromGitHub {
    owner = "staticjinja";
    repo = pname;
    rev = version;
    sha256 = "sha256-4IL+7ncJPd1e7k5oFRjQ6yvDjozcBAAZPf88biNTiLU=";
  };

  nativeBuildInputs = [
    poetry
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
  ];

  # The tests need to find and call the installed staticjinja executable
  preCheck = ''
    export PATH="$PATH:$out/bin";
  '';

  passthru.tests.version = testVersion {
    package = staticjinja;
  };

  meta = with lib; {
    description = "A library and cli tool that makes it easy to build static sites using Jinja2";
    homepage = "https://staticjinja.readthedocs.io/en/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz ];
  };
}
