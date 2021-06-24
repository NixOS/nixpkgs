{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "lazydocker";
  version = "0.12";

  src = fetchFromGitHub {
    owner = "jesseduffield";
    repo = "lazydocker";
    rev = "v${version}";
    sha256 = "sha256-bpc83DFAyrAQ3VI9saYe+10ZQqOHgscerRKRyjfYD4g=";
  };

  goPackagePath = "github.com/jesseduffield/lazydocker";

  subPackages = [ "." ];

  meta = with lib; {
    description = "A simple terminal UI for both docker and docker-compose";
    homepage = "https://github.com/jesseduffield/lazydocker";
    license = licenses.mit;
    maintainers = with maintainers; [ das-g Br1ght0ne ];
  };
}
