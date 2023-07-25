{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "air";
  version = "1.44.0";

  src = fetchFromGitHub {
    owner = "cosmtrek";
    repo = "air";
    rev = "v${version}";
    hash = "sha256-BLha2PDn7iF0B5OPVkJT6en1Znt/6xiHxuCj14ha9tc=";
  };

  vendorHash = "sha256-n2Ei+jckSYAydAdJnMaPc7FGUcwSbC49hk6nlDyDMPE=";

   ldflags = [ "-s" "-w" "-X=main.airVersion=${version}" ];

  subPackages = [ "." ];

  meta = with lib; {
    description = "Live reload for Go apps";
    homepage = "https://github.com/cosmtrek/air";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ Gonzih ];
  };
}
