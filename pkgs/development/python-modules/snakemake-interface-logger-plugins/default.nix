{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  snakemake-interface-common,
}:

buildPythonPackage rec {
  pname = "snakemake-interface-logger-plugins";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "snakemake";
    repo = "snakemake-interface-logger-plugins";
    tag = "v${version}";
    hash = "sha256-yvEjd4xBjjCocGK/HD1j5jcuy+syyXcEJGdsEFA0H40=";
  };

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [
    snakemake-interface-common
  ];

  pythonImportsCheck = [ "snakemake_interface_logger_plugins" ];

  meta = {
    description = "Stable interface for interactions between Snakemake and its logger plugins";
    homepage = "https://github.com/snakemake/snakemake-interface-logger-plugins";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
