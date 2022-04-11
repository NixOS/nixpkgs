{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, poetry-core
, rich
, typing-extensions
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "textual";
  version = "0.1.17";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Textualize";
    repo = pname;
    # tag is incorrect
    rev = "e13479bf72e8717b6c1c23a308465458297a6b33";
    sha256 = "1c9qzqb8l1kh9znam7mix0silaxz5bkrgwss3sd280hhgbsray9c";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    rich
    typing-extensions
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "textual" ];

  meta = with lib; {
    description = "TUI framework for Python inspired by modern web development";
    homepage = "https://github.com/Textualize/textual";
    license = licenses.mit;
    maintainers = with maintainers; [ jyooru ];
  };
}
