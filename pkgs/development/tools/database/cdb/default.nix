{
  stdenv,
  lib,
  fetchurl,
  fetchFromGitHub,
}:

let
  version = "0.75";
  sha256 = "1iajg55n47hqxcpdzmyq4g4aprx7bzxcp885i850h355k5vmf68r";
  # Please don’t forget to update the docs:
  # clone https://github.com/Profpatsch/cdb-docs
  # and create a pull request with the result of running
  # ./update <version>
  # from the repository’s root folder.
  docRepo = fetchFromGitHub {
    owner = "Profpatsch";
    repo = "cdb-docs";
    rev = "359b6c55c9e170ebfc88f3f38face8ae2315eacb";
    sha256 = "1y0ivviy58i0pmavhvrpznc4yjigjknff298gnw9rkg5wxm0gbbq";
  };

in
stdenv.mkDerivation {
  pname = "cdb";
  inherit version;

  src = fetchurl {
    url = "https://cr.yp.to/cdb/cdb-${version}.tar.gz";
    inherit sha256;
  };

  outputs = [
    "bin"
    "doc"
    "out"
  ];

  postPatch = ''
    # A little patch, borrowed from Archlinux AUR, borrowed from Gentoo Portage
    sed -e 's/^extern int errno;$/#include <errno.h>/' -i error.h
  '';

  postInstall = ''
    # don't use make setup, but move the binaries ourselves
    mkdir -p $bin/bin
    install -m 755 -t $bin/bin/ cdbdump cdbget cdbmake cdbmake-12 cdbmake-sv cdbstats cdbtest

    # patch paths in scripts
    function cdbmake-subst {
      substituteInPlace $bin/bin/$1 \
        --replace /usr/local/bin/cdbmake $bin/bin/cdbmake
    }
    cdbmake-subst cdbmake-12
    cdbmake-subst cdbmake-sv

    # docs
    mkdir -p $doc/share/cdb
    cp -r "${docRepo}/docs" $doc/share/cdb/html
  '';

  meta = {
    homepage = "https://cr.yp.to/cdb.html";
    license = lib.licenses.publicDomain;
    maintainers = [ lib.maintainers.Profpatsch ];
    platforms = lib.platforms.unix;
  };
}
