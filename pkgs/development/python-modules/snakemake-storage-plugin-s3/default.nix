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
  version = "0.2.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "snakemake";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-TKv/7b3+uhY18v7p1ZSya5KJEMUv4M1NkObP9vPzMxU=";
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
