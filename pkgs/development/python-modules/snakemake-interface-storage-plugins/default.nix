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
  version = "4.2.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "snakemake";
    repo = "snakemake-interface-storage-plugins";
    tag = "v${version}";
    hash = "sha256-Fhofj4xFdIPlrJgd0iOcEkGOnEXaDptrrv47luYE8wU=";
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
