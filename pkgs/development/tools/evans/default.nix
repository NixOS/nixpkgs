{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "evans";
  version = "0.10.6";

  src = fetchFromGitHub {
    owner = "ktr0731";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-rQwoiV87XMz/5GbVOyLDkfIKIgMzBcwY4ln73XCI/so=";
  };

  subPackages = [ "." ];

  vendorSha256 = "sha256-3R/HRfr1GjJwkCT6xQ51Y/zRcuvknunYKgVpM6jg+wY=";

  meta = with lib; {
    description = "More expressive universal gRPC client";
    homepage = "https://evans.syfm.me/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ diogox ];
  };
}
