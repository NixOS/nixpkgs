{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "evans";
  version = "0.10.8";

  src = fetchFromGitHub {
    owner = "ktr0731";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-2Fn+pPYknuQCofTNrgDbZ4A6C5hazSqKqlUOUG10ekU=";
  };

  subPackages = [ "." ];

  vendorSha256 = "sha256-IxlzSzFEIIBC32S7u1Lkbi/fOxFYlbockNAfl/tnJpA=";

  meta = with lib; {
    description = "More expressive universal gRPC client";
    homepage = "https://evans.syfm.me/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ diogox ];
  };
}
