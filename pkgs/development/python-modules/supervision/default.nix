{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  defusedxml,
  matplotlib,
  numpy,
  opencv-python,
  pillow,
  pydeprecate,
  pyyaml,
  requests,
  scipy,
  tqdm,
}:

buildPythonPackage (finalAttrs: {
  pname = "supervision";
  version = "0.29.0.post0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "roboflow";
    repo = "supervision";
    tag = finalAttrs.version;
    hash = "sha256-Pug95Srb8dv+3QctaZzF5Gz88eaOmlw4OkZWI7QFsXI=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    defusedxml
    matplotlib
    numpy
    opencv-python
    pillow
    pydeprecate
    pyyaml
    requests
    scipy
    tqdm
  ];

  # Tests require network access and GPU/model resources.
  doCheck = false;

  pythonImportsCheck = [ "supervision" ];

  meta = {
    description = "Set of easy-to-use utils that will come in handy in any Computer Vision project";
    homepage = "https://github.com/roboflow/supervision";
    changelog = "https://github.com/roboflow/supervision/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mahyarmirrashed ];
  };
})
