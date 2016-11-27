{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "wallabag-${version}";
  version = "2.1.4";

  # remember to rm -r var/cache/* after a rebuild or unexpected errors will occur

  src = fetchurl {
    url = "https://framabag.org/wallabag-release-${version}.tar.gz";
    sha256 = "0s4p9jls7jqq9jbcac21ibz9k5yxx0ifv2yhxlkia5kw9md20r7b";
  };

  outputs = [ "out" "doc" ];

  patchPhase = ''
    rm Makefile # use the "shared hosting" package with bundled dependencies
    substituteInPlace app/AppKernel.php \
      --replace "__DIR__" "getenv('WALLABAG_DATA')"
    substituteInPlace var/bootstrap.php.cache \
      --replace "\$this->rootDir = \$this->getRootDir()" "\$this->rootDir = getenv('WALLABAG_DATA')"
  ''; # exposes $WALLABAG_DATA

  installPhase = ''
    mv docs $doc/
    mkdir $out/
    cp -R * $out/
  '';

  meta = with stdenv.lib; {
    description = "Web page archiver";
    longDescription = ''
      wallabag is a self hostable application for saving web pages.

      To use, point the environment variable $WALLABAG_DATA to a directory called `app` that contains the folder `config` with wallabag's configuration files. These need to be updated every package upgrade. In `app`'s parent folder, a directory called `var` containing wallabag's data will be created.
      After a package upgrade, empty the `var/cache` folder.
    '';
    license = licenses.mit;
    homepage = http://wallabag.org;
    platforms = platforms.all;
  };
}

