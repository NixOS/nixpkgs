{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "envconsul";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "envconsul";
    rev = "v${version}";
    sha256 = "sha256-oV+dGenyNYdVLFn43p+J9TgIbliYOppAKr1ePlMF0d4=";
  };

  vendorSha256 = "sha256-kal1HR9zRVhQKR/ql63hju7XIHU1KRNDTAlOEqzYR4o=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/hashicorp/envconsul/version.Name=envconsul"
  ];

  meta = with lib; {
    homepage = "https://github.com/hashicorp/envconsul/";
    description = "Read and set environmental variables for processes from Consul";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.mpl20;
    maintainers = with maintainers; [ pradeepchhetri ];
  };
}
