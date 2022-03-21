{ lib
, stdenv
, fetchurl
}:

# Point the environment variable $WALLABAG_DATA to a data directory
# that contains the folder `app/config` which must be a clone of
# wallabag's configuration files with your customized `parameters.yml`.
# These need to be updated every package upgrade.
#
# After a package upgrade, empty the `var/cache` folder or unexpected
# error will occur.

let
  pname = "wallabag";
  version = "2.4.3";
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://static.wallabag.org/releases/wallabag-release-${version}.tar.gz";
    hash = "sha256-u6TflAzxoaxjLhNMv5ua+NPBv4kxGycgz2QXnhtDHTo=";
  };

  patches = [
    ./wallabag-data.patch # exposes $WALLABAG_DATA
  ];

  dontBuild = true;

  installPhase = ''
    mkdir $out
    cp -R * $out/
  '';

  meta = with lib; {
    description = "wallabag is a self hostable application for saving web pages";
    longDescription = ''
      wallabag is a self-hostable PHP application allowing you to not
      miss any content anymore. Click, save and read it when you can.
      It extracts content so that you can read it when you have time.
    '';
    license = licenses.mit;
    homepage = "http://wallabag.org";
    changelog = "https://github.com/wallabag/wallabag/releases/tag/${version}";
    maintainers = with maintainers; [ schneefux ];
    platforms = platforms.all;
  };
}
