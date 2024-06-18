{ lib
, stdenv
, fetchurl
}:

# Point the environment variable $WALLABAG_DATA to a data directory
# that contains the folder `app` which must be a clone of
# wallabag's configuration files with your customized `parameters.yml`.
# In practice you need to copy `${pkgs.wallabag}/app` and the
# customizzed `parameters.yml` to $WALLABAG_DATA.
# These need to be updated every package upgrade.
#
# After a package upgrade, empty the `var/cache` folder or unexpected
# error will occur.

let
  pname = "wallabag";
  version = "2.6.9";
in
stdenv.mkDerivation {
  inherit pname version;

  # Release tarball includes vendored files
  src = fetchurl {
    url = "https://github.com/wallabag/wallabag/releases/download/${version}/wallabag-${version}.tar.gz";
    hash = "sha256-V4s5/y9fFAmZ+WnUxU03UyRivEihD1ZUKQOOq4TLEKw=";
  };

  patches = [
    ./wallabag-data.patch # exposes $WALLABAG_DATA
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -R * $out/

    runHook postInstall
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
