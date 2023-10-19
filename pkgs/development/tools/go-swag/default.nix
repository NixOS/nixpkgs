{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "go-swag";
  version = "1.8.12";

  src = fetchFromGitHub {
    owner = "swaggo";
    repo = "swag";
    rev = "v${version}";
    sha256 = "sha256-2rnaPN4C4pn9Whk5X2z1VVxm679EUpQdumJZx5uulr4=";
  };

  vendorHash = "sha256-yQPmiK1CQNn3sr482OEkdRLK6YP8CvPMA/nPGdVJbMc=";

  subPackages = [ "cmd/swag" ];

  meta = with lib; {
    description = "Automatically generate RESTful API documentation with Swagger 2.0 for Go";
    homepage = "https://github.com/swaggo/swag";
    license = licenses.mit;
    maintainers = with maintainers; [ stephenwithph ];
    mainProgram = "swag";
  };
}
