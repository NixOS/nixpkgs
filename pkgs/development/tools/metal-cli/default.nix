{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "metal-cli";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "equinix";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Ekwucff12FIjaZ8qDvonhTdz7+DRpPLMGz2yqaCy+Bc=";
  };

  vendorSha256 = "sha256-F8d5i9jvjY11Pv6w0ZXI3jr0Wix++B/w9oRTuJGpQfE=";

  doCheck = false;

  meta = with lib; {
    description = "Official Equinix Metal CLI";
    homepage = "https://github.com/equinix/metal-cli/";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne nshalman ];
  };
}
