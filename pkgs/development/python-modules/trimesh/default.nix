{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  numpy,
  lxml,

  # optional deps
  colorlog,
  manifold3d,
  charset-normalizer,
  jsonschema,
  networkx,
  svg-path,
  pycollada,
  shapely,
  xxhash,
  rtree,
  httpx,
  scipy,
  pillow,
  mapbox-earcut,
  embreex,
}:

buildPythonPackage (finalAttrs: {
  pname = "trimesh";
  version = "4.12.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mikedh";
    repo = "trimesh";
    tag = finalAttrs.version;
    hash = "sha256-+Xmy3/GSnfj7u1sapMscoCGlRsz00IkUzEo9CJ5Ja3s=";
  };

  build-system = [ setuptools ];

  dependencies = [ numpy ];

  optional-dependencies = {
    easy = [
      colorlog
      manifold3d
      charset-normalizer
      lxml
      jsonschema
      networkx
      svg-path
      pycollada
      shapely
      xxhash
      rtree
      httpx
      scipy
      pillow
      # vhacdx # not packaged
      mapbox-earcut
    ]
    ++ lib.optionals embreex.meta.available [
      embreex
    ];
  };

  nativeCheckInputs = [
    lxml
    pytestCheckHook
  ]
  # embreex is maintained by trimesh devs
  ++ lib.optionals embreex.meta.available [
    embreex
    rtree
  ];

  disabledTests = [
    # requires loading models which aren't part of the Pypi tarball
    "test_load"
  ];

  enabledTestPaths = [
    "tests/test_minimal.py"
  ]
  ++ lib.optionals embreex.meta.available [
    "tests/test_ray.py"
  ];

  pythonImportsCheck = [
    "trimesh"
    "trimesh.ray"
    "trimesh.path"
    "trimesh.path.exchange"
    "trimesh.scene"
    "trimesh.voxel"
    "trimesh.visual"
    "trimesh.viewer"
    "trimesh.exchange"
    "trimesh.resources"
    "trimesh.interfaces"
  ];

  meta = {
    description = "Python library for loading and using triangular meshes";
    homepage = "https://trimesh.org/";
    changelog = "https://github.com/mikedh/trimesh/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    mainProgram = "trimesh";
    maintainers = with lib.maintainers; [
      pbsds
    ];
  };
})
