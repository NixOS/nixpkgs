{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  boto3,
  botocore,
  poetry-core,
  snakemake,
  snakemake-interface-storage-plugins,
  snakemake-interface-common,
  urllib3,
}:

buildPythonPackage rec {
  pname = "snakemake-storage-plugin-s3";
  version = "0.2.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "snakemake";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-tH4KLswRPberlaBlRCEJSPmUfkcwVkB9YbD/3LYJx0s=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    boto3
    botocore
    snakemake-interface-storage-plugins
    snakemake-interface-common
    urllib3
  ];

  nativeCheckInputs = [ snakemake ];

  pythonImportsCheck = [ "snakemake_storage_plugin_s3" ];

  meta = with lib; {
    description = "Snakemake storage plugin for S3 API storage (AWS S3, MinIO, etc.)";
    homepage = "https://github.com/snakemake/snakemake-storage-plugin-s3";
    license = licenses.mit;
    maintainers = with maintainers; [ veprbl ];
  };
}
