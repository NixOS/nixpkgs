{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # build-system
  setuptools,
  # dependencies
  emoji,
  networkx,
  numpy,
  peft,
  platformdirs,
  protobuf,
  requests,
  torch,
  tqdm,
  transformers,
  udtools,
}:

buildPythonPackage (finalAttrs: {
  pname = "stanza";
  version = "1.12.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "stanfordnlp";
    repo = "stanza";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hUI8sZDwBK8ZRS9asyDiTqpoIGnGbHeH/Q9i/gasut0=";
  };
  patches = [
    ## Backports from 1.14.0
    # Rebased because they don't apply directly.
    # https://github.com/stanfordnlp/stanza/security/advisories/GHSA-c9h2-qmqw-qf6h
    # https://github.com/stanfordnlp/stanza/commit/4ca4b154af05d71a66586ea9d77b8782e19f3c67
    ./GHSA-2fwf-f686-7p34.patch
    # https://github.com/stanfordnlp/stanza/security/advisories/GHSA-487q-m798-cp85
    # https://github.com/stanfordnlp/stanza/commit/031ab2e4a350eec3c7e8abc89f37617c4669b361
    ./GHSA-487q-m798-cp85.patch
    # https://github.com/stanfordnlp/stanza/security/advisories/GHSA-2fwf-f686-7p34
    # https://github.com/stanfordnlp/stanza/commit/a7085e75abdf35f277754dda472bba4e6819bcbb
    ./GHSA-c9h2-qmqw-qf6h.patch
  ];

  build-system = [ setuptools ];

  dependencies = [
    emoji
    networkx
    numpy
    peft
    platformdirs
    protobuf
    requests
    torch
    tqdm
    transformers
    udtools
  ];

  # Most tests require resources from the network (models). Many of the ones that do run are slow
  # and some of them fail.
  #
  # Maintaining a list of "tests we can actually run in CI" isn't feasible, there are WAY too many
  # exceptions and no useful pytest marks.
  doCheck = false;

  pythonImportsCheck = [ "stanza" ];

  meta = {
    description = "Official Stanford NLP Python Library for Many Human Languages";
    homepage = "https://github.com/stanfordnlp/stanza/";
    changelog = "https://github.com/stanfordnlp/stanza/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      riotbib
      Stebalien
    ];
  };
})
