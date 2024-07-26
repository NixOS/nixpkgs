{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "air";
  version = "1.49.0";

  src = fetchFromGitHub {
    owner = "cosmtrek";
    repo = "air";
    rev = "v${version}";
    hash = "sha256-6XQakQXGFMepX29KeiLlGM6EI8tiIfmKQuqZQXYNoto=";
  };

  vendorHash = "sha256-vyuXmQEjy5kPk9cKosHx0JZSZxstYtCNyfLIlRt2bnk=";

   ldflags = [ "-s" "-w" "-X=main.airVersion=${version}" ];

  subPackages = [ "." ];

  meta = with lib; {
    description = "Live reload for Go apps";
    homepage = "https://github.com/cosmtrek/air";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ Gonzih ];
  };
}
