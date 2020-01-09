{ stdenv, fetchFromGitHub, python3Packages, docutils, }:

python3Packages.buildPythonApplication rec {
  pname = "httpie";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "jakubroztocil";
    repo = "httpie";
    rev = version;
    sha256 = "0y30sp0x3nmgzi4dqw1rc3705hnn36ij0zlyyx7g6fqdq8bd8p5q";
  };

  propagatedBuildInputs = with python3Packages; [ pygments requests setuptools ];
  dontUseSetuptoolsCheck = true;

  disabledTests = [
    "test_current_version"
    "test_error"
  ];

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
