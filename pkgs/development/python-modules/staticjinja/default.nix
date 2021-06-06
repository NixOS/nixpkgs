{ lib
, fetchFromGitHub
, buildPythonPackage
, poetry
, isPy27
, docopt
, easywatch
, jinja2
, pytestCheckHook
, pytest-check
, markdown
}:

buildPythonPackage rec {
  pname = "staticjinja";
  version = "2.0.0";
  format = "pyproject";

  # No tests in pypi
  src = fetchFromGitHub {
    owner = "staticjinja";
    repo = pname;
    rev = version;
    sha256 = "0z5y4l4sv4c7zmp6pj1ws3psq7i87xqbcmk648bmsa1d6prr1hil";
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
