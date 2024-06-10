{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "matterircd";
  version = "0.28.0";

  src = fetchFromGitHub {
    owner = "42wim";
    repo = "matterircd";
    rev = "v${version}";
    sha256 = "sha256-qA07i31fGLLIfWoCBW1f5nvf4AWEIkSXZh22F6rRnpM=";
  };

  vendorHash = null;

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Minimal IRC server bridge to Mattermost";
    mainProgram = "matterircd";
    homepage = "https://github.com/42wim/matterircd";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
