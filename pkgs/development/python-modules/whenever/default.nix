{ lib
, fetchFromGitHub
, pythonOlder
, buildPythonPackage
, poetry-core
, backports-zoneinfo
, tzdata
, pytestCheckHook
, pytest-mypy-plugins
, hypothesis
, freezegun
}:

buildPythonPackage rec {
  pname = "whenever";
  version = "0.5.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ariebovenberg";
    repo = "whenever";
    rev = "refs/tags/${version}";
    hash = "sha256-RH2614M91zYULNTQsr6JoKfxlnGyAJsCkB7oeiz7urs=";
  };

  postPatch = ''
    # unrecognized arguments since we don't use pytest-benchmark in nixpkgs
    substituteInPlace pytest.ini \
      --replace-fail '--benchmark-disable' '#--benchmark-disable'
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    tzdata
  ] ++ lib.optionals (pythonOlder "3.9") [
    backports-zoneinfo
  ];

  pythonImportsCheck = [ "whenever" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mypy-plugins
    hypothesis
    freezegun
  ];

  # early TDD, many tests are failing
  # TODO: try enabling on bump
  doCheck = false;

  meta = with lib; {
    description = "Strict, predictable, and typed datetimes";
    homepage = "https://github.com/ariebovenberg/whenever";
    changelog = "https://github.com/ariebovenberg/whenever/blob/${src.rev}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ pbsds ];
  };
}
