{
  lib,
  stdenv,
  fetchpatch,
  fetchFromGitHub,
  buildPythonApplication,
  click,
  pydantic,
  toml,
  watchdog,
  pytestCheckHook,
  pytest-cov-stub,
  rsync,
}:

buildPythonApplication rec {
  pname = "remote-exec";
  version = "1.13.3";

  src = fetchFromGitHub {
    owner = "remote-cli";
    repo = "remote";
    rev = "refs/tags/v${version}";
    hash = "sha256-rsboHJLOHXnpXtsVsvsfKsav8mSbloaq2lzZnU2pw6c=";
  };

  patches = [
    # relax install requirements
    # https://github.com/remote-cli/remote/pull/60.patch
    (fetchpatch {
      url = "https://github.com/remote-cli/remote/commit/a2073c30c7f576ad7ceb46e39f996de8d06bf186.patch";
      hash = "sha256-As0j+yY6LamhOCGFzvjUQoXFv46BN/tRBpvIS7r6DaI=";
    })
  ];

  # remove legacy endpoints, we use --multi now
  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail '"mremote' '#"mremote'
  '';

  dependencies = [
    click
    pydantic
    toml
    watchdog
  ];

  doCheck = true;

  nativeCheckInputs = [
    rsync
  ];

  checkInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  disabledTestPaths = lib.optionals stdenv.isDarwin [
    # `watchdog` dependency does not correctly detect fsevents on darwin.
    # this only affects `remote --stream-changes`
    "test/test_file_changes.py"
  ];

  meta = with lib; {
    description = "Work with remote hosts seamlessly via rsync and ssh";
    homepage = "https://github.com/remote-cli/remote";
    changelog = "https://github.com/remote-cli/remote/releases/tag/v${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ pbsds ];
  };
}
