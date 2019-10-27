{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "lazydocker";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "jesseduffield";
    repo = "lazydocker";
    rev = "v${version}";
    sha256 = "03l6gs4p9p8g0ai6wqg9024rp0pd13m0b9y3sy1ww5afwxb82br6";
  };

  goPackagePath = "github.com/jesseduffield/lazydocker";

  subPackages = [ "." ];

  meta = with stdenv.lib; {
    description = "A simple terminal UI for both docker and docker-compose";
    homepage = https://github.com/jesseduffield/lazydocker;
    license = licenses.mit;
    maintainers = with maintainers; [ das-g ];
  };
}
