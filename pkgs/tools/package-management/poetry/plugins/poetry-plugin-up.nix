{ lib
, fetchFromGitHub
, buildPythonPackage
, poetry-core
, pytestCheckHook
, pytest-mock
, poetry
}:

buildPythonPackage rec {
  pname = "poetry-plugin-up";
<<<<<<< HEAD
  version = "0.4.0";
=======
  version = "0.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "MousaZeidBaker";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-ENw+6DdQkRLnAlIuIEdZzIsFP7ILqA9WatlVZYNJSxw=";
=======
    hash = "sha256-QDfXgLkwh5rfyNZv0S7+cq6ubldXsbuCiTr6VYx8ZQs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    poetry-core
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
    poetry
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  meta = with lib; {
    description = "Poetry plugin to simplify package updates";
    homepage = "https://github.com/MousaZeidBaker/poetry-plugin-up";
    changelog = "https://github.com/MousaZeidBaker/poetry-plugin-up/releases/tag/${version}";
    license = licenses.mit;
    maintainers = [ maintainers.k900 ];
  };
}
