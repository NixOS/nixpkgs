{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "powerline-go";
  version = "1.11.0";
  name = "${pname}-${version}";
  rev = "v${version}";

  goPackagePath = "github.com/justjanne/powerline-go";

  src = fetchFromGitHub {
    owner = "justjanne";
    repo = pname;
    inherit rev;
    sha256 = "1s3d9p4jf23n63n6vx3frnw3wkmg3kyiazapixy66790qkx6ddi9";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "A Powerline like prompt for Bash, ZSH and Fish";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ sifmelcara ];
  };
}
