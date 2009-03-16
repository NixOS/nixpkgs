{stdenv, fetchurl, perl, zlib, bzip2}:

stdenv.mkDerivation {
  name = "dpkg-1.14.25";
  
  src = fetchurl {
    url = mirror://debian/pool/main/d/dpkg/dpkg_1.14.25.tar.gz;
    sha256 = "1111r1ijyh149h7vby9vc8137hl9778ja3dln7ilkxhc1y1yjp2l";
  };

  configureFlags = "--without-dselect --with-admindir=/var/lib/dpkg";

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

    substituteInPlace src/Makefile.in --replace "install-data-local:" "disabled:"
    substituteInPlace dpkg-split/Makefile.in --replace "install-data-local:" "disabled:"
  '';

  buildInputs = [perl zlib bzip2];

  meta = {
    description = "The Debian package manager";
    homepage = http://wiki.debian.org/Teams/Dpkg;
  };
}
