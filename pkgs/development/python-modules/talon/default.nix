{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  python,
  setuptools,
  cssselect,
  html5lib,
  lxml,
  regex,

  mock,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "talon";
  version = "1.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mailgun";
    repo = "talon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WYZ7tHh0fdAiWtMMomBv9MPcCfLEk1jvNa/ADDc02ck=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    cssselect
    html5lib
    lxml
    regex
  ];

  postInstall = ''
    ln -s talon $out/${python.sitePackages}/talon_core
  '';

  pythonImportsCheck = [
    "talon"
    "talon_core"
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  meta = {
    description = "Mailgun library to extract message quotations and signatures";
    homepage = "https://github.com/mailgun/talon";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ phanirithvij ];
    # dependency for Karrot https://nlnet.nl/project/Karrot-UX/
    teams = with lib.teams; [ ngi ];
  };
})
