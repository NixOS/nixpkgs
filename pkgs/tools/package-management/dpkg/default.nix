{ stdenv, fetchurl, perl, zlib, bzip2, xz, makeWrapper }:

stdenv.mkDerivation rec {
  name = "dpkg-${version}";
  version = "1.18.6";

  src = fetchurl {
    url = "mirror://debian/pool/main/d/dpkg/dpkg_${version}.tar.xz";
    sha256 = "18nywp0gs8bnywll9qrcg8g1fli4p5xd6h8sazhsmrxgp8iw62yx";
  };

  postPatch = ''
    # dpkg tries to force some dependents like debian-devscripts to use
    # -fstack-protector-strong - not (yet?) a good idea. Disable for now:
    substituteInPlace scripts/Dpkg/Vendor/Debian.pm \
      --replace "stackprotectorstrong => 1" "stackprotectorstrong => 0"
  '';

  configureFlags = [
    "--disable-dselect"
    "--with-admindir=/var/lib/dpkg"
    "PERL_LIBDIR=$(out)/${perl.libPrefix}"
  ];

  preConfigure = ''
    # Nice: dpkg has a circular dependency on itself. Its configure
    # script calls scripts/dpkg-architecture, which calls "dpkg" in
    # $PATH. It doesn't actually use its result, but fails if it
    # isn't present, so make a dummy available.
    touch $TMPDIR/dpkg
    chmod +x $TMPDIR/dpkg
    PATH=$TMPDIR:$PATH

    for i in $(find . -name Makefile.in); do
      substituteInPlace $i --replace "install-data-local:" "disabled:" ;
    done
  '';

  buildInputs = [ perl zlib bzip2 xz ];
  nativeBuildInputs = [ makeWrapper ];

  postInstall =
    ''
      for i in $out/bin/*; do
        if head -n 1 $i | grep -q perl; then
          wrapProgram $i --prefix PERL5LIB : $out/${perl.libPrefix}
        fi
      done

      mkdir -p $out/etc/dpkg
      cp -r scripts/t/origins $out/etc/dpkg
    '';

  meta = with stdenv.lib; {
    description = "The Debian package manager";
    homepage = http://wiki.debian.org/Teams/Dpkg;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mornfall nckx ];
  };
}
