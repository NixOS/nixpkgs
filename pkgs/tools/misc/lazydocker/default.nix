{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "lazydocker";
  version = "0.8";

  src = fetchFromGitHub {
    owner = "jesseduffield";
    repo = "lazydocker";
    rev = "v${version}";
    sha256 = "02x03nmkbj0133bziaqmqlh3x515w3n01iqvg7q6b55r7nan7hv7";
  };

  goPackagePath = "github.com/jesseduffield/lazydocker";

  subPackages = [ "." ];

  meta = with stdenv.lib; {
    description = "A simple terminal UI for both docker and docker-compose";
    homepage = "https://github.com/jesseduffield/lazydocker";
    license = licenses.mit;
    maintainers = with maintainers; [ das-g filalex77 ];
  };
}
