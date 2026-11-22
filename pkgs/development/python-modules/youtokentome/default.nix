{
  lib,
  buildPythonPackage,
  click,
  cython,
  fetchFromGitHub,
  setuptools,
  tabulate,
  tokenizers,
}:

buildPythonPackage (finalAttrs: {
  pname = "youtokentome";
  version = "1.0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "VKCOM";
    repo = "YouTokenToMe";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+GI752Ih7Ou1wyChR2y80BJmeTYdHWLPX6A1lvMyLGU=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail 'version="1.0.6",' 'version = "${finalAttrs.version}",'
  '';

  build-system = [ setuptools ];

  nativeBuildInputs = [ cython ];

  dependencies = [
    click
    tabulate
  ];

  # Tests are outdated
  doCheck = false;

  pythonImportsCheck = [ "youtokentome" ];

  meta = {
    description = "Unsupervised text tokenizer";
    homepage = "https://github.com/VKCOM/YouTokenToMe";
    changelog = "https://github.com/VKCOM/YouTokenToMe/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "yttm";
  };
})
