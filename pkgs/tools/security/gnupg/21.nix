{ fetchurl, fetchpatch, stdenv, pkgconfig, libgcrypt, libassuan, libksba
, libiconv, npth, gettext, texinfo, pcsclite, sqlite

# Each of the dependencies below are optional.
# Gnupg can be built without them at the cost of reduced functionality.
, pinentry ? null, guiSupport ? true
, adns ? null, gnutls ? null, libusb ? null, openldap ? null
, readline ? null, zlib ? null, bzip2 ? null
}:

with stdenv.lib;

assert guiSupport -> pinentry != null;

stdenv.mkDerivation rec {
  name = "gnupg-${version}";

  version = "2.1.18";

  src = fetchurl {
    url = "mirror://gnupg/gnupg/${name}.tar.bz2";
    sha256 = "157rrv3ly9j2k0acz43nhiba5hfl6h7048jvj55wwqjmgsmnyk6h";
  };

  buildInputs = [
    pkgconfig libgcrypt libassuan libksba libiconv npth gettext texinfo
    readline libusb gnutls adns openldap zlib bzip2 sqlite
  ];

  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isDarwin "-lintl";

  patches = [
    ./fix-libusb-include-path.patch
    # TODO: Remove the following two patches on the next gnupg release after 2.1.18
    (fetchpatch {
      name = "scd-Backport-two-fixes-from-master";
      url = "https://anonscm.debian.org/git/pkg-gnupg/gnupg2.git/plain/debian/patches/0028-scd-Backport-two-fixes-from-master.patch?h=debian/2.1.18-6";
      sha256 = "01l2s4s7kp6j2f3qd371arq7pfphvncc9k1m63rqm0kyzy9jk20k";
    })
    (fetchpatch {
      name = "scd-Fix-use-case-of-PC-SC";
      url = "https://anonscm.debian.org/git/pkg-gnupg/gnupg2.git/plain/debian/patches/0029-scd-Fix-use-case-of-PC-SC.patch?h=debian/2.1.18-6";
      sha256 = "0lxqj614fialbqs2x0z13q5ikq2rc9xwphmkly179qs03d4mawsz";
    })
  ];
  postPatch = stdenv.lib.optionalString stdenv.isLinux ''
    sed -i 's,"libpcsclite\.so[^"]*","${pcsclite}/lib/libpcsclite.so",g' scd/scdaemon.c
  ''; #" fix Emacs syntax highlighting :-(

  pinentryBinaryPath = pinentry.binaryPath or "bin/pinentry";
  configureFlags = optional guiSupport "--with-pinentry-pgm=${pinentry}/${pinentryBinaryPath}";

  postInstall = ''
    mkdir -p $out/lib/systemd/user
    for f in doc/examples/systemd-user/*.{service,socket} ; do
      substitute $f $out/lib/systemd/user/$(basename $f) \
        --replace /usr/bin $out/bin
    done
  '';

  meta = with stdenv.lib; {
    homepage = http://gnupg.org;
    description = "A complete and free implementation of the OpenPGP standard";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ wkennington peti fpletz vrthra ];
    platforms = platforms.all;
  };
}
