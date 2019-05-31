{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "powerline-go";
  version = "1.12.1";
  name = "${pname}-${version}";
  rev = "v${version}";

  goPackagePath = "github.com/justjanne/powerline-go";

  src = fetchFromGitHub {
    owner = "justjanne";
    repo = pname;
    inherit rev;
    sha256 = "0r2n3hjgr7c7nwwcph7i2lv3709z9cyc8gmsinlzjwny998akyf4";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "A Powerline like prompt for Bash, ZSH and Fish";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ sifmelcara ];
  };
}
