{ lib
, fetchFromGitHub
, buildPythonPackage
, poetry
, docopt
, easywatch
, jinja2
, pytestCheckHook
, pytest-check
, markdown
}:

buildPythonPackage rec {
  pname = "staticjinja";
  version = "2.0.1";
  format = "pyproject";

  # No tests in pypi
  src = fetchFromGitHub {
    owner = "staticjinja";
    repo = pname;
    rev = version;
    sha256 = "sha256-sGon3+So4EuVRTUqcP9omfJ91wBzJSm7CSkuefX3S+8=";
  };

  nativeBuildInputs = [
    poetry
  ];

  propagatedBuildInputs = [
    jinja2
    docopt
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

  meta = with lib; {
    description = "A library and cli tool that makes it easy to build static sites using Jinja2";
    homepage = "https://staticjinja.readthedocs.io/en/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz ];
  };
}
