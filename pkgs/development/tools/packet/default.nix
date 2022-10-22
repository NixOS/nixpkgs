{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "packet";
  version = "2.2.2";

  goPackagePath = "github.com/ebsarr/packet";

  src = fetchFromGitHub {
    owner = "ebsarr";
    repo = "packet";
    rev = "v${version}";
    sha256 = "sha256-jm9u+LQE48aqO6CLdLZAw38woH1phYnEYpEsRbNwyKI=";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "a CLI tool to manage packet.net services";
    homepage = "https://github.com/ebsarr/packet";
    license = licenses.mit;
    maintainers = with maintainers; [ grahamc ];
    platforms = platforms.unix;
  };
}
