{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "fits-cloudctl";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "fi-ts";
    repo = "cloudctl";
    rev = "v${version}";
    sha256 = "sha256-QFmrBxNFzKrlvni2wbxM2tQP7z+QjLi9S7gqkVFWOmU=";
  };

  vendorSha256 = "sha256-aH1WGL7crF9VXHgcVxR0K3dNkV/J0wcBKgS9103dPes=";

  meta = with lib; {
    description = "Command-line client for FI-TS Finance Cloud Native services";
    homepage = "https://github.com/fi-ts/cloudctl";
    license = licenses.mit;
    maintainers = with maintainers; [ j0xaf ];
    mainProgram = "cloudctl";
  };
}
