{ stdenv, fetchFromGitHub, python3Packages, docutils, }:

python3Packages.buildPythonApplication rec {
  pname = "httpie";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "jakubroztocil";
    repo = "httpie";
    rev = version;
    sha256 = "0d0rsn5i973l9y0ws3xmnzaw4jwxdlryyjbasnlddph5mvkf7dq0";
  };

  propagatedBuildInputs = with python3Packages; [ pygments requests setuptools ];
  dontUseSetuptoolsCheck = true;
  patches = [ ./strip-venv.patch ];

  checkInputs = with python3Packages; [
    mock
    pytest
    pytest-httpbin
    pytestCheckHook
  ];

  # the tests call rst2pseudoxml.py from docutils
  preCheck = ''
    export PATH=${docutils}/bin:$PATH
  '';

  meta = {
    description = "A command line HTTP client whose goal is to make CLI human-friendly";
    homepage = https://httpie.org/;
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ antono relrod schneefux ];
  };
}
