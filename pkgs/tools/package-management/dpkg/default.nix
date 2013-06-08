{ stdenv, fetchurl, perl, zlib, bzip2, xz, makeWrapper }:

let version = "1.16.9"; in

stdenv.mkDerivation {
  name = "dpkg-${version}";

  src = fetchurl {
    url = "mirror://debian/pool/main/d/dpkg/dpkg_${version}.tar.xz";
    sha256 = "0ykby9x4x2zb7rfj30lfjcsrq2q32z2lnsrl8pbdvb2l9sx7zkbk";
  };

  patches = [ ./cache-arch.patch ];

  configureFlags = "--disable-dselect --with-admindir=/var/lib/dpkg PERL_LIBDIR=$(out)/${perl.libPrefix}";

  preConfigure = ''
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

  buildInputs = [ perl zlib bzip2 xz makeWrapper ];

  postInstall =
    ''
      for i in $out/bin/*; do
        if head -n 1 $i | grep -q perl; then
          wrapProgram $i --prefix PERL5LIB : $out/${perl.libPrefix}
        fi
      done # */
    '';

  meta = {
    description = "The Debian package manager";
    homepage = http://wiki.debian.org/Teams/Dpkg;
    platforms = stdenv.lib.platforms.linux;
  };
}
