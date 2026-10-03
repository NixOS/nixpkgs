{
  lib,
  basedpyright,
  beautifulsoup4,
  buildPythonPackage,
  cssselect,
  fetchFromGitHub,
  fetchpatch,
  html5lib,
  hypothesis,
  lxml,
  mypy,
  pdm-backend,
  pook,
  pyrefly,
  pyright,
  pytestCheckHook,
  pytest-revealtype-injector,
  rnc2rng,
  ty,
  typeguard,
  types-html5lib,
  typing-extensions,
  urllib3,
}:

buildPythonPackage (finalAttrs: {
  pname = "types-lxml";
  version = "2026.02.16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "abelcheung";
    repo = "types-lxml";
    tag = finalAttrs.version;
    hash = "sha256-bjJnVBFLjkuM/czbsEAcwWGbiuTyr9nyx9TCVLn/U+Y=";
  };

  patches = [
    # Support mypy 1.20
    # https://github.com/abelcheung/types-lxml/pull/127
    (fetchpatch {
      url = "https://github.com/attilaolah/types-lxml/commit/b86b6cd719eb3ddb1267d1e0a3d6b1f3e4a51ec0.patch";
      hash = "sha256-Mi4vS9PcrHxCovpiMVR/A7pWDRwvqsUCTTp3BW0JCjU=";
    })
    # Support pyright 1.1.410 and basedpyright 1.39.8
    # https://github.com/abelcheung/types-lxml/pull/128
    (fetchpatch {
      url = "https://github.com/attilaolah/types-lxml/commit/19b328abbb00820e4bb37d2cdc149ac4677c490b.patch";
      hash = "sha256-nydwteX3yo4vW+zkhBoWqp/0BWQXlT/lnJgFicNEqwU=";
      excludes = [ "pyproject.toml" ];
    })
  ];

  pythonRelaxDeps = [ "beautifulsoup4" ];

  build-system = [ pdm-backend ];

  dependencies = [
    cssselect
    beautifulsoup4
    types-html5lib
    typing-extensions
  ];

  optional-dependencies = {
    mypy = [ mypy ];
    pyright = [ pyright ];
  };

  nativeCheckInputs = [
    basedpyright
    beautifulsoup4
    html5lib
    hypothesis
    lxml
    pook
    pyrefly
    pytestCheckHook
    pytest-revealtype-injector
    rnc2rng
    ty
    typeguard
    urllib3
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  pythonImportsCheck = [ "lxml-stubs" ];

  pytestFlags = [
    "--revealtype-mypy-config=tests/mypy.ini"
    "--revealtype-pyrefly-config=tests/pyrefly.toml"
    # Upstream disables ty during runtime tests, see:
    # https://github.com/abelcheung/types-lxml/issues/104
    "--revealtype-disable-adapter=ty"
  ];

  # there may only be one conftest.py
  preCheck = ''
    rm -r tests/static
    mv tests/runtime/* tests/
    rmdir tests/runtime
    substituteInPlace tests/conftest.py \
      --replace-fail 'runtime.register_strategy' 'tests.register_strategy'
  '';

  disabledTests = [
    # BaseExceptionGroup: Hypothesis found multiple distinct failures.
    "test_index_arg_bad_1"
    "test_start_arg_bad_1"
    "test_stop_arg_bad_1"
  ];

  meta = {
    description = "Complete lxml external type annotation";
    homepage = "https://github.com/abelcheung/types-lxml";
    changelog = "https://github.com/abelcheung/types-lxml/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
