{ lib, stdenv, fetchurl, buildPackages
, pkg-config, texinfo
, gettext, libassuan, libgcrypt, libgpg-error, libiconv, libksba, npth
, adns, bzip2, gnutls, libusb1, openldap, readline, sqlite, zlib
, enableMinimal ? false
, withPcsc ? !enableMinimal, pcsclite
, guiSupport ? stdenv.isDarwin, pinentry
, withTpm2Tss ? !stdenv.isDarwin && !enableMinimal, tpm2-tss
, nixosTests
}:

assert guiSupport -> enableMinimal == false;

stdenv.mkDerivation rec {
  pname = "gnupg";
  version = "2.4.3";

  src = fetchurl {
    url = "mirror://gnupg/gnupg/${pname}-${version}.tar.bz2";
    hash = "sha256-onGubXMvb02AwlitnuiN2clMj9wzw+RTKMTXwSa9IZ0=";
  };

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ pkg-config texinfo ];
  buildInputs = [
    gettext libassuan libgcrypt libgpg-error libiconv libksba npth
  ] ++ lib.optionals (!enableMinimal) [
    adns bzip2 gnutls libusb1 openldap readline sqlite zlib
  ] ++ lib.optionals withTpm2Tss [ tpm2-tss ];

  patches = [
    ./fix-libusb-include-path.patch
    ./tests-add-test-cases-for-import-without-uid.patch
    ./accept-subkeys-with-a-good-revocation-but-no-self-sig.patch
    ./24-allow-import-of-previously-known-keys-even-without-UI.patch
    ./24-revert-rfc4880bis-defaults.patch
    # Patch for DoS vuln from https://seclists.org/oss-sec/2022/q3/27
    ./v3-0001-Disallow-compressed-signatures-and-certificates.patch
  ];

  postPatch = ''
    sed -i 's,\(hkps\|https\)://keyserver.ubuntu.com,hkps://keys.openpgp.org,g' configure configure.ac doc/dirmngr.texi doc/gnupg.info-1
    '' + lib.optionalString (stdenv.isLinux && withPcsc) ''
      sed -i 's,"libpcsclite\.so[^"]*","${lib.getLib pcsclite}/lib/libpcsclite.so",g' scd/scdaemon.c
    '';

  configureFlags = [
    "--sysconfdir=/etc"
    "--with-libgpg-error-prefix=${libgpg-error.dev}"
    "--with-libgcrypt-prefix=${libgcrypt.dev}"
    "--with-libassuan-prefix=${libassuan.dev}"
    "--with-ksba-prefix=${libksba.dev}"
    "--with-npth-prefix=${npth}"
  ]
  ++ lib.optional guiSupport "--with-pinentry-pgm=${pinentry}/${pinentry.binaryPath or "bin/pinentry"}"
  ++ lib.optional withTpm2Tss "--with-tss=intel"
  ++ lib.optional stdenv.isDarwin "--disable-ccid-driver";

  postInstall = if enableMinimal
  then ''
    rm -r $out/{libexec,sbin,share}
    for f in $(find $out/bin -type f -not -name gpg)
    do
      rm $f
    done
  '' else ''
    # add gpg2 symlink to make sure git does not break when signing commits
    ln -s $out/bin/gpg $out/bin/gpg2

    # Make libexec tools available in PATH
    for f in $out/libexec/; do
      if [[ "$(basename $f)" == "gpg-wks-client" ]]; then continue; fi
      ln -s $f $out/bin/$(basename $f)
    done

    for f in $out/libexec/; do
      if [[ "$(basename $f)" == "gpg-wks-client" ]]; then continue; fi
      ln -s $f $out/bin/$(basename $f)
    done
  '';

  enableParallelBuilding = true;

  passthru.tests = nixosTests.gnupg;

  meta = with lib; {
    homepage = "https://gnupg.org";
    changelog = "https://git.gnupg.org/cgi-bin/gitweb.cgi?p=${pname}.git;a=blob;f=NEWS;hb=refs/tags/${pname}-${version}";
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
