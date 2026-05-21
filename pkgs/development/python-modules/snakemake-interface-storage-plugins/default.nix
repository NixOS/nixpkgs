{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  humanfriendly,
  reretry,
  snakemake-interface-common,
  tenacity,
  throttler,
  wrapt,
}:

buildPythonPackage (finalAttrs: {
  pname = "snakemake-interface-storage-plugins";
  version = "4.4.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "snakemake";
    repo = "snakemake-interface-storage-plugins";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tqSIJnU1+DPx/GI5/wzMkoxpLyM/k/SO8FtejRv9Zls=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    humanfriendly
    reretry
    snakemake-interface-common
    tenacity
    throttler
    wrapt
  ];

  pythonImportsCheck = [ "snakemake_interface_storage_plugins" ];

  # No tests
  doCheck = false;

  meta = {
    description = "Stable interface for interactions between Snakemake and its storage plugins";
    changelog = "https://github.com/snakemake/snakemake-interface-storage-plugins/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/snakemake/snakemake-interface-storage-plugins";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ veprbl ];
  };
})
