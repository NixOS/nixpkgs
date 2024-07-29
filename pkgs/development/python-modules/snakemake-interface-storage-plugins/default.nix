{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  reretry,
  snakemake-interface-common,
  throttler,
  wrapt,
  snakemake,
}:

buildPythonPackage rec {
  pname = "snakemake-interface-storage-plugins";
  version = "3.2.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "snakemake";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-xfqxUla3qFnGZSFpWVCmtSJLqCK6XJF1OtDF1EDXbZU=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
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
