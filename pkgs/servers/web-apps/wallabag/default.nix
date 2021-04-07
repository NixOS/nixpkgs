{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "wallabag";
  version = "2.4.1";

  # remember to rm -r var/cache/* after a rebuild or unexpected errors will occur

  src = fetchurl {
    url = "https://static.wallabag.org/releases/wallabag-release-${version}.tar.gz";
    sha256 = "1dqf5ia66kjsnfad2xkm8w6jgs976mf9x0dcd73jybqfgs4j09kj";
  };

  outputs = [ "out" ];

  patches = [
    ./wallabag-data.patch # exposes $WALLABAG_DATA
  ];

  dontBuild = true;

  installPhase = ''
    mkdir $out/
    cp -R * $out/
  '';

  meta = with lib; {
    description = "Web page archiver";
    longDescription = ''
      wallabag is a self hostable application for saving web pages.

      Point the environment variable $WALLABAG_DATA to a data directory that contains the folder `app/config` which must be a clone of wallabag's configuration files with your customized `parameters.yml`. These need to be updated every package upgrade.
      After a package upgrade, empty the `var/cache` folder.
    '';
    license = licenses.mit;
    homepage = "http://wallabag.org";
    maintainers = with maintainers; [ schneefux ];
    platforms = platforms.all;
  };
}

