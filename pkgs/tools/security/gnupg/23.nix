{ fetchurl, fetchpatch, lib, stdenv, pkg-config, libgcrypt, libassuan, libksba
, libgpg-error, libiconv, npth, gettext, texinfo, buildPackages

# Each of the dependencies below are optional.
# Gnupg can be built without them at the cost of reduced functionality.
, guiSupport ? stdenv.isDarwin, enableMinimal ? false
, adns ? null, bzip2 ? null , gnutls ? null , libusb1 ? null , openldap ? null
, tpm2-tss ? null
, pcsclite ? null , pinentry ? null , readline ? null , sqlite ? null , zlib ? null
}:

with lib;

assert guiSupport -> pinentry != null && enableMinimal == false;

stdenv.mkDerivation rec {
  pname = "gnupg";
  version = "2.3.3";

  src = fetchurl {
    url = "mirror://gnupg/gnupg/${pname}-${version}.tar.bz2";
    sha256 = "0dz9x0r5021bhk1kjh29m1q13xbslwb8yn9qzcp7b9m1lrnvi2ap";
  };

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ pkg-config texinfo ];
  buildInputs = [
    libgcrypt libassuan libksba libiconv npth gettext
    readline libusb1 gnutls adns openldap zlib bzip2 sqlite
  ] ++ optional (!stdenv.isDarwin) tpm2-tss ;

  patches = [
    ./fix-libusb-include-path.patch
    ./tests-add-test-cases-for-import-without-uid.patch
    ./allow-import-of-previously-known-keys-even-without-UI.patch
    ./accept-subkeys-with-a-good-revocation-but-no-self-sig.patch
  ] ++ lib.optional stdenv.isDarwin [
    # Remove an innocent warning printed on systems without procfs
    # https://dev.gnupg.org/T5656
    (fetchpatch {
      url = "https://raw.githubusercontent.com/Homebrew/formula-patches/890be5f6af88e7913d177af87a50129049e681bb/gnupg/2.3.3-proc-error.patch";
      sha256 = "sha256-oiTa7Nf+AEmhZ683CJEaCb559PXJ6RpSSgRLpxz4CKU=";
    })
  ];
  postPatch = ''
    sed -i 's,hkps://hkps.pool.sks-keyservers.net,hkps://keys.openpgp.org,g' configure doc/dirmngr.texi doc/gnupg.info-1
    # Fix broken SOURCE_DATE_EPOCH usage - remove on the next upstream update
    sed -i 's/$SOURCE_DATE_EPOCH/''${SOURCE_DATE_EPOCH}/' doc/Makefile.am
    sed -i 's/$SOURCE_DATE_EPOCH/''${SOURCE_DATE_EPOCH}/' doc/Makefile.in
  '' + lib.optionalString (stdenv.isLinux && pcsclite != null) ''
    sed -i 's,"libpcsclite\.so[^"]*","${lib.getLib pcsclite}/lib/libpcsclite.so",g' scd/scdaemon.c
  '';

  pinentryBinaryPath = pinentry.binaryPath or "bin/pinentry";
  configureFlags = [
    "--with-libgpg-error-prefix=${libgpg-error.dev}"
    "--with-libgcrypt-prefix=${libgcrypt.dev}"
    "--with-libassuan-prefix=${libassuan.dev}"
    "--with-ksba-prefix=${libksba.dev}"
    "--with-npth-prefix=${npth}"
  ] ++ optional guiSupport "--with-pinentry-pgm=${pinentry}/${pinentryBinaryPath}"
  ++ optional ( (!stdenv.isDarwin) && (tpm2-tss != null) ) "--with-tss=intel";
  postInstall = if enableMinimal
  then ''
    rm -r $out/{libexec,sbin,share}
    for f in $(find $out/bin -type f -not -name gpg)
    do
      rm $f
    done
  '' else ''
    mkdir -p $out/lib/systemd/user
    for f in doc/examples/systemd-user/*.{service,socket} ; do
      substitute $f $out/lib/systemd/user/$(basename $f) \
        --replace /usr/bin $out/bin
    done

    # add gpg2 symlink to make sure git does not break when signing commits
    ln -s $out/bin/gpg $out/bin/gpg2

    # Make libexec tools available in PATH
    for f in $out/libexec/; do
      if [[ "$(basename $f)" == "gpg-wks-client" ]]; then continue; fi
      ln -s $f $out/bin/$(basename $f)
    done
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://gnupg.org";
    description = "Modern release of the GNU Privacy Guard, a GPL OpenPGP implementation";
    license = licenses.gpl3Plus;
    longDescription = ''
      The GNU Privacy Guard is the GNU project's complete and free
      implementation of the OpenPGP standard as defined by RFC4880.  GnuPG
      "modern" (2.1) is the latest development with a lot of new features.
      GnuPG allows to encrypt and sign your data and communication, features a
      versatile key management system as well as access modules for all kind of
      public key directories.  GnuPG, also known as GPG, is a command line tool
      with features for easy integration with other applications.  A wealth of
      frontend applications and libraries are available.  Version 2 of GnuPG
      also provides support for S/MIME.
    '';
    maintainers = with maintainers; [ fpletz vrthra ];
    platforms = platforms.all;
  };
}
