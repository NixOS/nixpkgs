{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "evans";
  version = "0.10.9";

  src = fetchFromGitHub {
    owner = "ktr0731";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Dim/8RXBMZTITGlT7F7TdAK9S2ct7w01861QqeT2FZk=";
  };

  subPackages = [ "." ];

  vendorSha256 = "sha256-HcD7MnUBPevGDckiWitIcp0z97FJmW3D0f9SySdouq8=";

  meta = with lib; {
    description = "More expressive universal gRPC client";
    homepage = "https://evans.syfm.me/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ diogox ];
  };
}
