{ lib
, fetchFromGitHub
, fetchpatch
, buildPythonPackage
, poetry-core
, pytestCheckHook
, pytest-mock
, poetry
}:

buildPythonPackage rec {
  pname = "poetry-plugin-up";
  version = "0.3.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "MousaZeidBaker";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-QDfXgLkwh5rfyNZv0S7+cq6ubldXsbuCiTr6VYx8ZQs=";
  };

  patches = [
    # https://github.com/MousaZeidBaker/poetry-plugin-up/pull/24
    (fetchpatch {
      url = "https://github.com/MousaZeidBaker/poetry-plugin-up/commit/31d78c547896efd27c2be0956a982638f32b07f8.patch";
      hash = "sha256-CkZgX/ES+VkfxBofxWeparXNjsdP4qcQ1I32zaBBmWo=";
    })
  ];

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
