{ lib, buildGoPackage, fetchFromGitHub
, pkg-config
, glib, libxml2
}:

buildGoPackage rec {
  pname = "ua";
  version = "unstable-2017-02-24";

  goPackagePath = "github.com/sloonz/ua";

  src = fetchFromGitHub {
    owner = "sloonz";
    repo = "ua";
    rev = "325dab92c60e0f028e55060f0c288aa70905fb17";
    sha256 = "sha256-LlpxWwKO+gZltkmpQyWaG+qhZFnmETFKIqlOxOzEohA=";
  };

  goDeps = ./deps.nix;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ glib libxml2 ];

  meta = with lib; {
    homepage = "https://github.com/sloonz/ua";
    license = licenses.isc;
    description = "Universal Aggregator";
    maintainers = with maintainers; [ ttuegel ];
  };
}
