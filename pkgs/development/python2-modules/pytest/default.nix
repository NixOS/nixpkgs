{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  attrs,
  hypothesis,
  py,
  setuptools-scm,
  setuptools,
  six,
  pluggy,
  funcsigs,
  isPy3k,
  more-itertools,
  atomicwrites,
  mock,
  writeText,
  pathlib2,
  wcwidth,
  packaging,
  isPyPy,
}:
buildPythonPackage rec {
  version = "4.6.11";
  format = "setuptools";
  pname = "pytest";

  src = fetchPypi {
    inherit pname version;
    sha256 = "50fa82392f2120cc3ec2ca0a75ee615be4c479e66669789771f1758332be4353";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pluggy>=0.12,<1.0" "pluggy>=0.12,<2.0"
  '';

  nativeCheckInputs = [
    hypothesis
    mock
  ];
  buildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [
    attrs
    py
    setuptools
    six
    pluggy
    more-itertools
    atomicwrites
    wcwidth
    packaging
  ]
  ++ lib.optionals (!isPy3k) [ funcsigs ]
  ++ lib.optionals (pythonOlder "3.6") [ pathlib2 ];

  doCheck = !isPyPy; # https://github.com/pytest-dev/pytest/issues/3460
  checkPhase = ''
    runHook preCheck

    # don't test bash builtins
    rm testing/test_argcomplete.py

    # determinism - this test writes non deterministic bytecode
    rm -rf testing/test_assertrewrite.py

    PYTHONDONTWRITEBYTECODE=1 $out/bin/py.test -x testing/ -k "not test_collect_pyargs_with_testpaths"
    runHook postCheck
  '';

  # Remove .pytest_cache when using py.test in a Nix build
  setupHook = writeText "pytest-hook" ''
    pytestcachePhase() {
        find $out -name .pytest_cache -type d -exec rm -rf {} +
    }

    appendToVar preDistPhases pytestcachePhase

    # pytest generates it's own bytecode files to improve assertion messages.
    # These files similar to cpython's bytecode files but are never laoded
    # by python interpreter directly. We remove them for a few reasons:
    # - files are non-deterministic: https://github.com/NixOS/nixpkgs/issues/139292
    #   (file headers are generatedt by pytest directly and contain timestamps)
    # - files are not needed after tests are finished
    pytestRemoveBytecodePhase () {
        # suffix is defined at:
        #    https://github.com/pytest-dev/pytest/blob/4.6.11/src/_pytest/assertion/rewrite.py#L32-L47
        find $out -name "*-PYTEST.py[co]" -delete
    }
    appendToVar preDistPhases pytestRemoveBytecodePhase
  '';

  meta = with lib; {
    homepage = "https://docs.pytest.org";
    description = "Framework for writing tests";
    maintainers = with maintainers; [
      lovek323
      madjar
      lsix
    ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
