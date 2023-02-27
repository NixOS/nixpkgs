{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "fits-cloudctl";
  version = "0.11.4";

  src = fetchFromGitHub {
    owner = "fi-ts";
    repo = "cloudctl";
    rev = "v${version}";
    sha256 = "sha256-rn9F6vCwnz+pweBPYskiAZSfwT9nOyFIJBA3xbmPDhk=";
  };

  vendorSha256 = "sha256-aime2pVJw3Bwt4KU2lxpYk0DmRphiZg3M32NWoGeZ+E=";

  meta = with lib; {
    description = "Command-line client for FI-TS Finance Cloud Native services";
    homepage = "https://github.com/fi-ts/cloudctl";
    license = licenses.mit;
    maintainers = with maintainers; [ j0xaf ];
    mainProgram = "cloudctl";
  };
}
