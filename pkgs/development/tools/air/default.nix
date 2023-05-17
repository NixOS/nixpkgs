{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "air";
  version = "1.43.0";

  src = fetchFromGitHub {
    owner = "cosmtrek";
    repo = "air";
    rev = "v${version}";
    hash = "sha256-gFMT/casY2ASbh0UzUjtgVGCiVFcFHBlvWlRptqRw3Y=";
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
