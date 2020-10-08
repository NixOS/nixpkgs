{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "lazydocker";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "jesseduffield";
    repo = "lazydocker";
    rev = "v${version}";
    sha256 = "08j2qp632fdmswnb92wxa9lhnal4mrmq6gmxaxngnxiqgkfx37zy";
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
