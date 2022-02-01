{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "air";
  version = "1.27.9";

  src = fetchFromGitHub {
    owner = "cosmtrek";
    repo = "air";
    rev = "v${version}";
    sha256 = "sha256-8VuCZoAV54TG8MiF6n5O8ZStGujfJ/7w95BYhe5/7dE=";
  };

  vendorSha256 = "sha256-u/v6RnzBU+zQEy3jjVITjUQiU7AT3wZoeeRFF+KqOvI=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Live reload for Go apps";
    homepage = "https://github.com/cosmtrek/air";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ Gonzih ];
  };
}
