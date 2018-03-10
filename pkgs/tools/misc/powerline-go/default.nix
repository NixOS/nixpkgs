{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "powerline-go";
  version = "1.8.2";
  name = "${pname}-${version}";
  rev = "v${version}";

  goPackagePath = "github.com/justjanne/powerline-go";

  src = fetchFromGitHub {
    owner = "justjanne";
    repo = pname;
    inherit rev;
    sha256 = "1q45hxbrnx0mgi7z1rqkxp47dk8yf4mzy62i0027fhr65aifq6xj";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "A Powerline like prompt for Bash, ZSH and Fish";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ sifmelcara ];
  };
}
