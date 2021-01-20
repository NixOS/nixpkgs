{ lib, stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "lazydocker";
  version = "0.10";

  src = fetchFromGitHub {
    owner = "jesseduffield";
    repo = "lazydocker";
    rev = "v${version}";
    sha256 = "04j5bcsxm2yf74zkphnjrg8j3w0v6bsny8sg2k4gbisgshl1i3p8";
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
