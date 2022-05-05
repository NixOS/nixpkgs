{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "evans";
  version = "0.10.5";

  src = fetchFromGitHub {
    owner = "ktr0731";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-3gl4m0zTe8y4KLMAy3I7YD4Q7gLrRf3QsJap2IGX9Tk=";
  };

  subPackages = [ "." ];

  vendorSha256 = "sha256-BYOrby7tlQJ0ZjZHCeDWzsCv7jBfwX9RX1weLfEz+cU=";

  meta = with lib; {
    description = "More expressive universal gRPC client";
    homepage = "https://evans.syfm.me/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ diogox ];
  };
}
