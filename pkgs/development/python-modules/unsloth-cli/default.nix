{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonAtLeast,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  nest-asyncio,
  pydantic,
  pyyaml,
  typer,
}:

buildPythonPackage (finalAttrs: {
  pname = "unsloth-cli";
  version = "2026.4.5";
  pyproject = true;

  disabled = pythonAtLeast "3.14";

  src = fetchPypi {
    pname = "unsloth";
    inherit (finalAttrs) version;
    hash = "sha256-35+IMV/WHVi0iGnOxtfSZNKo0+0ZlNVlbNtA5tXw9sE=";
  };

  postPatch = ''
        # first replace same as in unsloth package
        # second fix of attempt to use models version for this pacakge versions, wrong
        substituteInPlace pyproject.toml \
          --replace-fail 'requires = ["setuptools==80.9.0", "setuptools-scm==9.2.0"]' \
                         'requires = ["setuptools", "setuptools-scm"]' \
          --replace-fail 'version = {attr = "unsloth.models._utils.__version__"}' \
                         'version = {attr = "unsloth_cli.__version__"}'
        echo '__version__ = "${finalAttrs.version}"' >> unsloth_cli/__init__.py

        # NOTE: project retains some garbage, so we ignore it as it does not breaks build

        # split out only cli from monorepo
        rm -rf unsloth studio

        # not part of this cli, but part of package used by cli
        substituteInPlace pyproject.toml \
          --replace-fail \
            'exclude = [
        "images*",
        "tests*",
        "kernels/moe*",
        "studio.frontend.node_modules*",
    ]' \
            'include = ["unsloth_cli*"]'
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    nest-asyncio
    pydantic
    pyyaml
    typer
  ];

  # The upstream package metadata belongs to the combined `unsloth`
  # distribution. The split CLI package only needs the CLI dependencies above.
  pythonRemoveDeps = [
    "accelerate"
    "bitsandbytes"
    "datasets"
    "diffusers"
    "hf_transfer"
    "huggingface_hub"
    "numpy"
    "packaging"
    "peft"
    "protobuf"
    "psutil"
    "sentencepiece"
    "torch"
    "torchvision"
    "tqdm"
    "transformers"
    "triton"
    "trl"
    "tyro"
    "unsloth_zoo"
    "wheel"
    "xformers"
  ];

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/unsloth --help > /dev/null

    runHook postInstallCheck
  '';

  pythonImportsCheck = [ "unsloth_cli" ];

  meta = {
    description = "Command-line interface for Unsloth training, inference, export, and Studio commands";
    homepage = "https://github.com/unslothai/unsloth";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ dzmitry-lahoda ];
    mainProgram = "unsloth";
  };
})
