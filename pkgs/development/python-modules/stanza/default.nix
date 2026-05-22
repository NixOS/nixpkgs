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
  version = "1.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "stanfordnlp";
    repo = "stanza";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uarx5HY6sxm2Fr12Vti4IluqOhFosf8QYIP2WMxdFfI=";
  };

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
