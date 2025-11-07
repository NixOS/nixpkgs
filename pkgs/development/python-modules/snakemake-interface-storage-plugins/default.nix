{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  humanfriendly,
  reretry,
  snakemake-interface-common,
  throttler,
  wrapt,
}:

buildPythonPackage rec {
  pname = "snakemake-interface-storage-plugins";
  version = "4.2.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "snakemake";
    repo = "snakemake-interface-storage-plugins";
    tag = "v${version}";
    hash = "sha256-gez2UptlCorf42qHnnG31gfjzcTm9uyerF23N2fmTiM=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    humanfriendly
    reretry
    snakemake-interface-common
    throttler
    wrapt
  ];

  pythonImportsCheck = [ "snakemake_interface_storage_plugins" ];

  meta = with lib; {
    description = "This package provides a stable interface for interactions between Snakemake and its storage plugins";
    homepage = "https://github.com/snakemake/snakemake-interface-storage-plugins";
    license = licenses.mit;
    maintainers = with maintainers; [ veprbl ];
  };
}
