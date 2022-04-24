{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "evans";
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "ktr0731";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-4KHJodqmx03uQ+HJBWmKbIBvkLh80N4fHnYL4GLciNc=";
  };

  subPackages = [ "." ];

  vendorSha256 = "sha256-to75gON3Kl0GHgVhhrW8I6GWOg9/KrUts3rwDLAfFnM=";

  meta = with lib; {
    description = "More expressive universal gRPC client";
    homepage = "https://evans.syfm.me/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ diogox ];
  };
}
