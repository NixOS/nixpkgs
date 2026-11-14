{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  requests,
  tqdm,
  wasabi,
  plac,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "unidic";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "polm";
    repo = "unidic-py";
    tag = "v${finalAttrs.version}";
    hash = "sha256-srhQDXGgoIMhYuCbyQB3kF4LrODnoOqLbjBQMvhPieY=";
  };

  patches = [ ./fix-download-directory.patch ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "wasabi>=0.6.0,<1.0.0" "wasabi"
  '';

  build-system = [ setuptools ];

  dependencies = [
    requests
    tqdm
    wasabi
    plac
  ];

  nativeBuildInputs = [
    setuptools-scm
  ];

  pythonImportsCheck = [ "unidic" ];

  meta = {
    description = "Contemporary Written Japanese dictionary";
    homepage = "https://github.com/polm/unidic-py";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
