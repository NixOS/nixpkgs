{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "go-swag";
  version = "1.8.8";

  src = fetchFromGitHub {
    owner = "swaggo";
    repo = "swag";
    rev = "v${version}";
    sha256 = "sha256-xERuD15NEmBqosNAUmWEGqWVXc9jLA9HrbZrqmzhLFA=";
  };

  vendorSha256 = "sha256-iu4rSgB7Gu5n1Sgu0jU9QwdwvuZ5rAqysvKuBnJd2jQ=";

  subPackages = [ "cmd/swag" ];

  meta = with lib; {
    description = "Automatically generate RESTful API documentation with Swagger 2.0 for Go";
    homepage = "https://github.com/swaggo/swag";
    license = licenses.mit;
    maintainers = with maintainers; [ stephenwithph ];
    mainProgram = "swag";
  };
}
