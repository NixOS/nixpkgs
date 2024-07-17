{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "vault-medusa";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "jonasvinther";
    repo = "medusa";
    rev = "v${version}";
    sha256 = "sha256-8lbaXcu+o+grbFPJxZ6p/LezxDFCUvOQyX49zX4V/v0=";
  };

  vendorHash = "sha256-/8wusZt0BQ//HCokjiSpsgsGb19FggrGrEuhCrwm9L0=";

  meta = with lib; {
    description = "A cli tool for importing and exporting Hashicorp Vault secrets";
    mainProgram = "medusa";
    homepage = "https://github.com/jonasvinther/medusa";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
