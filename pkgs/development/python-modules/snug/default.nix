{ buildPythonPackage, lib, fetchFromGitHub, glibcLocales
, pytest, pytest-mock, gentools
, typing, singledispatch, pythonOlder
}:

buildPythonPackage rec {
  pname = "snug";
  version = "1.3.4";

  # Pypi doesn't ship the tests, so we fetch directly from GitHub
  src = fetchFromGitHub {
    owner = "ariebovenberg";
    repo = "snug";
    rev = "v${version}";
    sha256 = "0jmg0sivz9ljazlnsrrqaizrb3r7asy5pa0dj3idx49gbig4589i";
  };

  # Prevent unicode decoding error in setup.py
  # while reading README.rst and HISTORY.rst
  buildInputs = [ glibcLocales ];
  LC_ALL = "en_US.UTF-8";

  propagatedBuildInputs =
    lib.optionals (pythonOlder "3.4") [ singledispatch ] ++
    lib.optionals (pythonOlder "3.5") [ typing ];

  checkInputs = [ pytest pytest-mock gentools ];
  checkPhase = "pytest";

  meta = with lib; {
    description = "Tiny toolkit for writing reusable interactions with web APIs";
    license = licenses.mit;
    homepage = https://snug.readthedocs.io/en/latest/;
    maintainers = with maintainers; [ mredaelli ];
  };

}
