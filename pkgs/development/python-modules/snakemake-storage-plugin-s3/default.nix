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
  version = "0.3.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "snakemake";
    repo = "snakemake-storage-plugin-s3";
    tag = "v${version}";
    hash = "sha256-mHDlY4OZYoTp7G0COM4PYe7S7LptiM/9DnAMADLThbg=";
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
    changelog = "https://github.com/snakemake/snakemake-storage-plugin-s3/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ veprbl ];
  };
}
