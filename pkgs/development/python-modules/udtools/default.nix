{
  lib,
  nix-update-script,
  buildPythonPackage,
  fetchFromGitHub,
  python,
  setuptools,
  # dependencies
  regex,
  udapi,
}:

buildPythonPackage (finalAttrs: {
  pname = "udtools";
  version = "0.2.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "UniversalDependencies";
    repo = "tools";
    tag = "py${finalAttrs.version}";
    hash = "sha256-P1gx6JRq1oWCXzB2uO/eCrw8ZgJ+0Y/0cvlLtj+X7SY=";
  };

  sourceRoot = "${finalAttrs.src.name}/udtools";

  build-system = [ setuptools ];

  dependencies = [
    udapi
    regex
  ];

  # pycheck tests are not enabled because they try to import packages/types
  # that I can't seem to find anywhere on the internet.
  # https://github.com/UniversalDependencies/tools/issues/158
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
