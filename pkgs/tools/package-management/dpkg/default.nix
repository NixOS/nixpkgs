{stdenv, fetchurl, perl, zlib, bzip2, xz}:

let version = "1.16.8"; in

stdenv.mkDerivation {
  name = "dpkg-${version}";

  src = fetchurl {
    url = "mirror://debian/pool/main/d/dpkg/dpkg_${version}.tar.xz";
    sha256 = "4a1f4611390d93f1f198d910d3a4e4913b3cf81702b31f585a1872ca98df0eaa";
  };

  configureFlags = "--disable-dselect --with-admindir=/var/lib/dpkg ";

  preConfigure = ''
    # Can't use substitute pending resolution of NIXPKGS-89.
    sed -s 's^/usr/bin/perl^${perl}/bin/perl^' -i scripts/dpkg-architecture.pl

    # Nice: dpkg has a circular dependency on itself.  Its configure
    # script calls scripts/dpkg-architecture, which calls "dpkg" in
    # $PATH.  It doesn't actually use its result, but fails if it
    # isn't present.  So make a dummy available.
    touch $TMPDIR/dpkg
    chmod +x $TMPDIR/dpkg
    PATH=$TMPDIR:$PATH

    for i in $(find . -name Makefile.in); do 
      substituteInPlace $i --replace "install-data-local:" "disabled:" ;
    done
  '';

  buildInputs = [ perl zlib bzip2 xz ];

  meta = {
    description = "The Debian package manager";
    homepage = http://wiki.debian.org/Teams/Dpkg;
  };
}
