{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "powerline-go";
  version = "1.10.0";
  name = "${pname}-${version}";
  rev = "v${version}";

  goPackagePath = "github.com/justjanne/powerline-go";

  src = fetchFromGitHub {
    owner = "justjanne";
    repo = pname;
    inherit rev;
    sha256 = "1bmgim61cx6i4m24a474nm3w4zqjflm0wnw3y24299n9dj14izs3";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "A Powerline like prompt for Bash, ZSH and Fish";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ sifmelcara ];
  };
}
