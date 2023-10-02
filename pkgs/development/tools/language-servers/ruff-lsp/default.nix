{ lib
, stdenv
, pythonOlder
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, ruff
, pygls
, lsprotocol
, hatchling
, typing-extensions
, pytestCheckHook
, python-lsp-jsonrpc
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "ruff-lsp";
  version = "0.0.39";
  pyproject = true;
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "astral-sh";
    repo = "ruff-lsp";
    rev = "v${version}";
    hash = "sha256-hbnSx59uSzXHeAhZPZnCzxl+mCZIdr29uUPfQCsm/Ww=";
  };

  patches = [
    # update tests to fix compatibility with ruff 0.0.291
    # https://github.com/astral-sh/ruff-lsp/pull/250
    (fetchpatch {
      name = "bump-ruff-version.patch";
      url = "https://github.com/astral-sh/ruff-lsp/commit/35691407c4f489416a46fd2e88ef037b1204feb7.patch";
      hash = "sha256-D6k2BWDUqN4GBhjspRwg84Idr7fvKMbmAAkG3I1YOH4=";
      excludes = [
        "requirements.txt"
        "requirements-dev.txt"
      ];
    })
  ];

  postPatch = ''
    # ruff binary added to PATH in wrapper so it's not needed
    sed -i '/"ruff>=/d' pyproject.toml
  '';

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    pygls
    lsprotocol
    typing-extensions
  ];

  # fails in linux sandbox
  doCheck = stdenv.isDarwin;

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    python-lsp-jsonrpc
    ruff
  ];

  makeWrapperArgs = [
    # prefer ruff from user's PATH, that's usually desired behavior
    "--suffix PATH : ${lib.makeBinPath [ ruff ]}"

    # Unset ambient PYTHONPATH in the wrapper, so ruff-lsp only ever runs with
    # its own, isolated set of dependencies. This works because the correct
    # PYTHONPATH is set in the Python script, which runs after the wrapper.
    "--unset PYTHONPATH"
  ];

  meta = with lib; {
    description = "A Language Server Protocol implementation for Ruff";
    homepage = "https://github.com/astral-sh/ruff-lsp";
    changelog = "https://github.com/astral-sh/ruff-lsp/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda kalekseev ];
  };
}
