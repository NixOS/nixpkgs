{ lib
, buildPythonPackage
, fetchFromGitHub
, boto3
, botocore
, poetry-core
, snakemake
, snakemake-interface-storage-plugins
, snakemake-interface-common
, urllib3
}:

buildPythonPackage rec {
  pname = "snakemake-storage-plugin-s3";
  version = "0.2.10";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "snakemake";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-k21DRQdSUFkdwNb7MZJmClhIg+pdSc7H6FkDrbf4DT8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace ">=2.0,<2.2" "*"
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    boto3
    botocore
    snakemake-interface-storage-plugins
    snakemake-interface-common
    urllib3
  ];

  nativeCheckInputs = [
    snakemake
  ];

  pythonImportsCheck = [ "snakemake_storage_plugin_s3" ];

  meta = with lib; {
    description = "A Snakemake storage plugin for S3 API storage (AWS S3, MinIO, etc.)";
    homepage = "https://github.com/snakemake/snakemake-storage-plugin-s3";
    license = licenses.mit;
    maintainers = with maintainers; [ veprbl ];
  };
}
