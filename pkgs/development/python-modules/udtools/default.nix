{
  lib,
  nix-update-script,
  buildPythonPackage,
  fetchFromGitHub,
  python,
  setuptools,
  pytestCheckHook,
  # dependencies
  regex,
  udapi,
}:

buildPythonPackage (finalAttrs: {
  pname = "udtools";
  version = "0.2.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "UniversalDependencies";
    repo = "tools";
    tag = "py${finalAttrs.version}";
    hash = "sha256-PeMIjxHU99HHNwT/D6UiS5HqxXj66ngRTYfA1xn9uOw=";
  };

  sourceRoot = "${finalAttrs.src.name}/udtools";

  build-system = [ setuptools ];

  dependencies = [
    udapi
    regex
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "udtools" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=py(.*)" ];
  };

  postInstall = ''
    install -dm755 $out/${python.sitePackages}/udtools/data
    cp $src/data/* $out/${python.sitePackages}/udtools/data
  '';

  meta = {
    description = "Python tools for Universal Dependencies";
    homepage = "https://universaldependencies.org/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      Stebalien
    ];
  };
})
