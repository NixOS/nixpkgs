{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  numpy,
  opencv-python,
  requests,
  rich,
  scipy,
  supervision,
}:

buildPythonPackage (finalAttrs: {
  pname = "trackers";
  version = "2.4.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "roboflow";
    repo = "trackers";
    tag = finalAttrs.version;
    hash = "sha256-BJsRRKz+NyjldT88ZVTkqd0pVul/rLicFA9QpUSOGDg=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    numpy
    opencv-python
    requests
    rich
    scipy
    supervision
  ];

  # Tests require external data downloads and GPU resources.
  doCheck = false;

  pythonImportsCheck = [ "trackers" ];

  meta = {
    description = "Unified library for object tracking featuring clean room re-implementations of leading multi-object tracking algorithms";
    homepage = "https://github.com/roboflow/trackers";
    changelog = "https://github.com/roboflow/trackers/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mahyarmirrashed ];
  };
})
