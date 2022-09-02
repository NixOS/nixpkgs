{ lib, stdenv, fetchurl, perl, zlib, bzip2, xz, zstd
, makeWrapper, coreutils, autoreconfHook, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "dpkg";
  version = "1.21.1ubuntu2.1";

  src = fetchurl {
    url = "mirror://ubuntu/pool/main/d/dpkg/dpkg_${version}.tar.xz";
    sha256 = "sha256-YvVQbQn2MhOIOE43VO0H1QsKIYCsjNAFzKMoFeSrqZk=";
  };

  configureFlags = [
    "--disable-dselect"
    "--with-admindir=/var/lib/dpkg"
    "PERL_LIBDIR=$(out)/${perl.libPrefix}"
    (lib.optionalString stdenv.isDarwin "--disable-linker-optimisations")
    (lib.optionalString stdenv.isDarwin "--disable-start-stop-daemon")
  ];

  enableParallelBuilding = true;

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

  patchPhase = ''
    patchShebangs .

    # Dpkg commands sometimes calls out to shell commands
    substituteInPlace lib/dpkg/dpkg.h \
       --replace '"dpkg-deb"' \"$out/bin/dpkg-deb\" \
       --replace '"dpkg-split"' \"$out/bin/dpkg-split\" \
       --replace '"dpkg-query"' \"$out/bin/dpkg-query\" \
       --replace '"dpkg-divert"' \"$out/bin/dpkg-divert\" \
       --replace '"dpkg-statoverride"' \"$out/bin/dpkg-statoverride\" \
       --replace '"dpkg-trigger"' \"$out/bin/dpkg-trigger\" \
       --replace '"dpkg"' \"$out/bin/dpkg\" \
       --replace '"debsig-verify"' \"$out/bin/debsig-verify\" \
       --replace '"rm"' \"${coreutils}/bin/rm\" \
       --replace '"cat"' \"${coreutils}/bin/cat\" \
       --replace '"diff"' \"${coreutils}/bin/diff\"
  '';

  buildInputs = [ perl zlib bzip2 xz zstd ];
  nativeBuildInputs = [ makeWrapper perl autoreconfHook pkg-config ];

  postInstall =
    ''
      for i in $out/bin/*; do
        if head -n 1 $i | grep -q perl; then
          substituteInPlace $i --replace \
            "${perl}/bin/perl" "${perl}/bin/perl -I $out/${perl.libPrefix}"
        fi
      done

      mkdir -p $out/etc/dpkg
      cp -r scripts/t/origins $out/etc/dpkg
    '';

  meta = with lib; {
    description = "The Debian package manager";
    homepage = "https://wiki.debian.org/Teams/Dpkg";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ siriobalmelli ];
  };
}
