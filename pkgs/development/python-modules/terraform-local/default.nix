{
  lib,
  buildPythonPackage,
  fetchPypi,
  python-hcl2,
  packaging,
  localstack-client,
}:

buildPythonPackage rec {
  pname = "terraform_local";
  version = "0.18.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8opiMd6ZxgWRJIDa0vhZJh5bmsO/CaHgGJ4sdEdxZLc=";
  };

  dependencies = [
    python-hcl2
    packaging
    localstack-client
  ];

  meta = with lib; {
    description = "Terraform CLI wrapper to deploy your Terraform applications directly to LocalStack";
    homepage = "https://github.com/localstack/terraform-local";
    license = licenses.asl20;
    maintainers = with maintainers; [ shivaraj-bh ];
  };
}
