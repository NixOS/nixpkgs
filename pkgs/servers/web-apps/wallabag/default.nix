{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "wallabag-${version}";
  version = "2.3.3";

  # remember to rm -r var/cache/* after a rebuild or unexpected errors will occur

  src = fetchurl {
    url = "https://static.wallabag.org/releases/wallabag-release-${version}.tar.gz";
    sha256 = "12q5daigqn4xqp9pyfzac881qm9ywrflm8sivhl3spczyh41gwpg";
  };

  outputs = [ "out" ];

  patches = [ ./wallabag-data.patch ]; # exposes $WALLABAG_DATA

  prePatch = ''
    rm Makefile # use the "shared hosting" package with bundled dependencies
  '';

  installPhase = ''
    mkdir $out/
    cp -R * $out/
  '';

  meta = with stdenv.lib; {
    description = "Web page archiver";
    longDescription = ''
      wallabag is a self hostable application for saving web pages.

      Point the environment variable $WALLABAG_DATA to a data directory that contains the folder `app/config` which must be a clone of wallabag's configuration files with your customized `parameters.yml`. These need to be updated every package upgrade.
      After a package upgrade, empty the `var/cache` folder.
    '';
    license = licenses.mit;
    homepage = http://wallabag.org;
    maintainers = with maintainers; [ schneefux ];
    platforms = platforms.all;
  };
}

