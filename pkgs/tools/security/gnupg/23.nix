{ fetchurl, fetchpatch, lib, stdenv, pkg-config, libgcrypt, libassuan, libksba
, libgpg-error, libiconv, npth, gettext, texinfo, buildPackages
, guiSupport ? stdenv.isDarwin, enableMinimal ? false
, adns, bzip2, gnutls, libusb1, openldap
, tpm2-tss, pcsclite, pinentry, readline, sqlite, zlib
}:

assert guiSupport -> enableMinimal == false;

stdenv.mkDerivation rec {
  pname = "gnupg";
  version = "2.3.7";

  src = fetchurl {
    url = "mirror://gnupg/gnupg/${pname}-${version}.tar.bz2";
    sha256 = "sha256-7hY6X7nsmf/BsY5l+u+NCGgAxXE9FaZyq1fTeZ2oNmk=";
  };

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ pkg-config texinfo ];
  buildInputs = [
    libgcrypt libassuan libksba libiconv npth gettext
  ] ++ lib.optionals (!enableMinimal) ([
    readline libusb1 gnutls adns openldap zlib bzip2 sqlite
  ] ++ lib.optional (!stdenv.isDarwin) tpm2-tss);

  patches = [
    ./fix-libusb-include-path.patch
    ./tests-add-test-cases-for-import-without-uid.patch
    ./allow-import-of-previously-known-keys-even-without-UI.patch
    ./accept-subkeys-with-a-good-revocation-but-no-self-sig.patch

    # Patch for DoS vuln from https://seclists.org/oss-sec/2022/q3/27
    ./v3-0001-Disallow-compressed-signatures-and-certificates.patch

    # Fix regression when using YubiKey devices as smart cards.
    # See https://dev.gnupg.org/T6070 for details.
    # Committed upstream, remove this patch when updating to the next release.
    (fetchpatch {
      url = "https://dev.gnupg.org/rGf34b9147eb3070bce80d53febaa564164cd6c977?diff=1";
      sha256 = "sha256-J/PLSz8yiEgtGv+r3BTGTHrikV70AbbHQPo9xbjaHFE=";
    })
  ];
  postPatch = ''
    sed -i 's,\(hkps\|https\)://keyserver.ubuntu.com,hkps://keys.openpgp.org,g' configure configure.ac doc/dirmngr.texi doc/gnupg.info-1
  '' + lib.optionalString (stdenv.isLinux && (!enableMinimal)) ''
    sed -i 's,"libpcsclite\.so[^"]*","${lib.getLib pcsclite}/lib/libpcsclite.so",g' scd/scdaemon.c
  '';

  pinentryBinaryPath = pinentry.binaryPath or "bin/pinentry";
  configureFlags = [
    "--with-libgpg-error-prefix=${libgpg-error.dev}"
    "--with-libgcrypt-prefix=${libgcrypt.dev}"
    "--with-libassuan-prefix=${libassuan.dev}"
    "--with-ksba-prefix=${libksba.dev}"
    "--with-npth-prefix=${npth}"
  ] ++ lib.optional guiSupport "--with-pinentry-pgm=${pinentry}/${pinentryBinaryPath}"
  ++ lib.optional ((!stdenv.isDarwin) && (!enableMinimal)) "--with-tss=intel";
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
    mainProgram = "gpg";
  };
}
