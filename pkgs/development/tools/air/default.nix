{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "air";
  version = "1.29.0";

  src = fetchFromGitHub {
    owner = "cosmtrek";
    repo = "air";
    rev = "v${version}";
    hash = "sha256-JbFSEfm8SVyJBgZju3kfIv5WK/kFYTqkU0EH5HXl9cc=";
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
