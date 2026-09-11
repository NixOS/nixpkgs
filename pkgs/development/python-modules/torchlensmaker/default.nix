{
  lib,
  fetchFromGitHub,
  buildPythonPackage,

  # build-system
  hatchling,

  # dependencies
  indicio,
  ipython,
  jaxtyping,
  matplotlib,
  tlmviewer,
  torchimplicit,

  # tests
  onnxruntime,
  onnxscript,
  pytestCheckHook,

  # passthru
  callPackage,
  python,
}:

buildPythonPackage (finalAttrs: {
  pname = "torchlensmaker";
  version = "0.0.14";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "victorpoughon";
    repo = "torchlensmaker";
    tag = "v${finalAttrs.version}";
    hash = "sha256-B9gjBo8piV9wNIDhV0YWV3nBtCgZlcMZ22KJ92Wn3lc=";
  };

  sourceRoot = "${finalAttrs.src.name}/torchlensmaker";

  postPatch = ''
    # Fix Jupyter widget: unpkg serves the UMD build for the bare URL,
    # which has no ESM default export. Point at the ES module bundle and
    # defend against a missing default export.
    substituteInPlace src/torchlensmaker/viewer/script_template.js \
      --replace-fail \
        'https://unpkg.com/tlmviewer@''${version}' \
        'https://unpkg.com/tlmviewer@''${version}/dist/tlmviewer-''${version}.es.js' \
      --replace-fail \
        'const tlmviewer = module.default;' \
        'const tlmviewer = module.default ?? module;'
  '';

  build-system = [
    hatchling
  ];

  dependencies = [
    indicio
    ipython
    jaxtyping
    matplotlib
    tlmviewer
    torchimplicit
  ];

  pythonRelaxDeps = [
    "matplotlib"
  ];

  pythonImportsCheck = [
    "torchlensmaker"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    onnxruntime
    onnxscript
  ];

  passthru = {
    tests = callPackage ./tests { };

    # nix-shell -A python3Packages.torchlensmaker.pyEnv
    pyEnv = python.withPackages (
      ps: with ps; [
        ipython
        jupyter
        torchlensmaker
      ]
    );
  };

  meta = {
    description = "Python library for modeling and designing optical systems";
    longDescription = ''
      Torch Lens Maker is an open-source Python library for differentiable
      geometric optics based on [PyTorch](https://pytorch.org/).

      The goal of the project is to be able to design complex real-world
      optical systems (lenses, mirrors, etc.) using modern computer code and
      state-of-the art numerical optimization.
    '';
    homepage = "https://github.com/victorpoughon/torchlensmaker";
    changelog = "https://github.com/victorpoughon/torchlensmaker/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
  };
})
