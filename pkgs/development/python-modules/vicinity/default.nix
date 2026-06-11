{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  setuptools-scm,
  numpy,
  orjson,
  tqdm,
  datasets,
  hnswlib,
  pynndescent,
  annoy,
  faiss,
  usearch,
}:

buildPythonPackage (finalAttrs: {
  pname = "vicinity";
  version = "0.4.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MinishLab";
    repo = "vicinity";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VRDCtPjuuEXeiJ2r4PqCDGnTyYlb3OVeemsN9VrS6Wc=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  env.SETUPTOOLS_SCM_PRETEND_VERSION = finalAttrs.version;

  dependencies = [
    numpy
    orjson
    tqdm
  ];

  pythonImportsCheck = [ "vicinity" ];

  passthru.optional-dependencies = {
    huggingface = [ datasets ];
    hnsw = [ hnswlib ];
    pynndescent = [ pynndescent ];
    annoy = [ annoy ];
    faiss = [ faiss ];
    usearch = [ usearch ];
  };

  meta = {
    description = "Lightweight Nearest Neighbors with Flexible Backends";
    homepage = "https://github.com/MinishLab/vicinity";
    changelog = "https://github.com/MinishLab/vicinity/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.gdifolco ];
  };
})
