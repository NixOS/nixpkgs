{ stdenv, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  name = "shadowfox-${version}";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "SrKomodo";
    repo = "shadowfox-updater";
    rev = "v${version}";
    sha256 = "07695hba72q722d18q75pwa45azg9jibj6vqnhwb7mnwz2i7hkkc";
  };

  goPackagePath = "github.com/SrKomodo/shadowfox-updater";
  goDeps = ./deps.nix;

  buildFlags = "--tags release";

  meta = with stdenv.lib; {
    description = ''
      This project aims at creating a universal dark theme for Firefox while
      adhering to the modern design principles set by Mozilla.
    '';
    homepage = https://overdodactyl.github.io/ShadowFox/;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ infinisil ];
  };
}
