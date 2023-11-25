{ lib
, stdenv
, fetchFromGitHub
, buildPythonApplication
, click
, pydantic_1
, toml
, watchdog
, pytestCheckHook
, rsync
}:

buildPythonApplication rec {
  pname = "remote-exec";
  version = "1.13.2";

  src = fetchFromGitHub {
    owner = "remote-cli";
    repo = "remote";
    rev = "refs/tags/v${version}";
    hash = "sha256-xaxkN6XukV9HiLYehwVTBZB8bUyjgpfg+pPfAGrOkgo=";
  };

  # remove legacy endpoints, we use --multi now
  postPatch = ''
    substituteInPlace setup.py \
      --replace '"mremote' '#"mremote'
  '';

  propagatedBuildInputs = [
    click
    pydantic_1
    toml
    watchdog
  ];

  # disable pytest --cov
  preCheck = ''
    rm setup.cfg
  '';

  doCheck = true;

  nativeCheckInputs = [
    rsync
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = lib.optionals stdenv.isDarwin [
    # `watchdog` dependency does not correctly detect fsevents on darwin.
    # this only affects `remote --stream-changes`
    "test/test_file_changes.py"
  ];

  meta = with lib; {
    description = "Work with remote hosts seamlessly via rsync and ssh";
    homepage = "https://github.com/remote-cli/remote";
    license = licenses.bsd2;
    maintainers = with maintainers; [ pbsds ];
  };
}
