{ lib
, stdenv
, buildPythonPackage
<<<<<<< HEAD
, click
, colorama
, coverage
, fetchpatch
, fetchPypi
, flit-core
, pytest-sugar
, pytest-xdist
, pytestCheckHook
, pythonOlder
, rich
, shellingham
, typing-extensions
=======
, colorama
, fetchpatch
, fetchPypi
, flit-core
, click
, pytestCheckHook
, rich
, shellingham
, pytest-xdist
, pytest-sugar
, coverage
, pythonOlder
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "typer";
<<<<<<< HEAD
  version = "0.9.0";
=======
  version = "0.7.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-UJIv15rqL0dRqOBAj/ENJmK9DIu/qEdVppnzutopeLI=";
  };

  patches = [
    # https://github.com/tiangolo/typer/pull/651
    (fetchpatch {
      name = "unpin-flit-core-dependency.patch";
      url = "https://github.com/tiangolo/typer/commit/78a0ee2eec9f54ad496420e177fdaad84984def1.patch";
      hash = "sha256-VVUzFvF2KCXXkCfCU5xu9acT6OLr+PlQQPeVGONtU4A=";
    })
  ];
=======
    hash = "sha256-/3l4RleKnyogG1NEKu3rVDMZRmhw++HHAeq2bddoEWU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "rich >=10.11.0,<13.0.0" "rich"
  '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    click
<<<<<<< HEAD
    typing-extensions
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  passthru.optional-dependencies = {
    all = [
      colorama
      shellingham
      rich
    ];
  };

  nativeCheckInputs = [
    coverage # execs coverage in tests
    pytest-sugar
    pytest-xdist
    pytestCheckHook
  ] ++ passthru.optional-dependencies.all;

  preCheck = ''
    export HOME=$(mktemp -d);
  '';
<<<<<<< HEAD

  disabledTests = [
    "test_scripts"
    # Likely related to https://github.com/sarugaku/shellingham/issues/35
    # fails also on Linux
=======
  disabledTests = lib.optionals stdenv.isDarwin [
    # likely related to https://github.com/sarugaku/shellingham/issues/35
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    "test_show_completion"
    "test_install_completion"
  ] ++ lib.optionals (stdenv.isLinux && stdenv.isAarch64) [
    "test_install_completion"
  ];

  pythonImportsCheck = [
    "typer"
  ];

  meta = with lib; {
    description = "Library for building CLI applications";
    homepage = "https://typer.tiangolo.com/";
<<<<<<< HEAD
    changelog = "https://github.com/tiangolo/typer/releases/tag/${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ winpat ];
  };
}
