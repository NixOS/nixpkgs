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
  version = "0.7.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "MousaZeidBaker";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-RjyRnCrHLKBJm8WMzQd0WcfpO8Ve+ydvUTN4EnVunlI=";
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
