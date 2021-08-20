{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "consul-template";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "consul-template";
    rev = "v${version}";
    sha256 = "sha256-XzsewkHaFIq1kvFDHIsnhfhtLPLFRin7YrhiZuF1+co=";
  };

  vendorSha256 = "sha256-/4ZY4YRGsUSL2e6uYPJ9tWEvXDjU5/L56yf49pUkJ2E=";

  # consul-template tests depend on vault and consul services running to
  # execute tests so we skip them here
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/hashicorp/consul-template/";
    description = "Generic template rendering and notifications with Consul";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.mpl20;
    maintainers = with maintainers; [ cpcloud pradeepchhetri ];
  };
}
