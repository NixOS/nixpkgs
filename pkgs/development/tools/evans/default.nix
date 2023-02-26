{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "evans";
  version = "0.10.10";

  src = fetchFromGitHub {
    owner = "ktr0731";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-4MPb2sEdjcfu7Lupeplpj+3ebEfJB/Obf7fhoa8EZTY=";
  };

  subPackages = [ "." ];

  vendorSha256 = "sha256-oyFPycyQoYnN261kmGhkN9NMPMA6XChf4jXlYezKiCo=";

  meta = with lib; {
    description = "More expressive universal gRPC client";
    homepage = "https://evans.syfm.me/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ diogox ];
  };
}
