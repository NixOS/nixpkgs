{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "matterircd";
  version = "0.27.1";

  src = fetchFromGitHub {
    owner = "42wim";
    repo = "matterircd";
    rev = "v${version}";
    sha256 = "sha256-bDM+P9UwH4cpieOQQfEi2xIKTRQ1zInW9iFK3yAU1Xk=";
  };

  vendorHash = null;

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Minimal IRC server bridge to Mattermost";
    homepage = "https://github.com/42wim/matterircd";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
