{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  cssselect,
  fetchFromGitHub,
  html5lib,
  hypothesis,
  lxml,
  mypy,
  pdm-backend,
  pook,
  pyright,
  pytestCheckHook,
  pytest-revealtype-injector,
  rnc2rng,
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
    beautifulsoup4
    html5lib
    hypothesis
    lxml
    pook
    pytestCheckHook
    pytest-revealtype-injector
    rnc2rng
    typeguard
    urllib3
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  pythonImportsCheck = [ "lxml-stubs" ];

  pytestFlags = [
    "--revealtype-disable-adapter=basedpyright"
    "--revealtype-disable-adapter=pyrefly"
    "--revealtype-disable-adapter=ty"
    "--revealtype-mypy-config=tests/mypy.ini"
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
    "test_start_arg_bad_1"
    "test_stop_arg_bad_1"
    "test_index_arg_bad_1"
  ];

  meta = {
    description = "Complete lxml external type annotation";
    homepage = "https://github.com/abelcheung/types-lxml";
    changelog = "https://github.com/abelcheung/types-lxml/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
