{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "air";
  version = "1.27.10";

  src = fetchFromGitHub {
    owner = "cosmtrek";
    repo = "air";
    rev = "v${version}";
    sha256 = "sha256-mgFLelf0TPjJK/keQz+s52fKlruSn6+KTPj+waJuQdU=";
  };

  vendorSha256 = "sha256-MEIPkron42OJioV7PPhnLWVevjKDs5Bw3jDmvZbac9s=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Live reload for Go apps";
    homepage = "https://github.com/cosmtrek/air";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ Gonzih ];
  };
}
