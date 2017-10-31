{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "wallabag-${version}";
  version = "2.2.3";

  # remember to rm -r var/cache/* after a rebuild or unexpected errors will occur

  src = fetchurl {
    url = "https://static.wallabag.org/releases/wallabag-release-${version}.tar.gz";
    sha256 = "0myqarwny9p53g2gmwmg1mcn17jlx5ah0bri13panhf7ryvmrzhk";
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
    mkdir -p $doc/share/doc
    mv docs $doc/share/doc/wallabag
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

