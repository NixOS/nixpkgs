{ lib, stdenv, fetchurl, buildPackages
, pkg-config, texinfo
, gettext, libassuan, libgcrypt, libgpg-error, libiconv, libksba, npth
, adns, bzip2, gnutls, libusb1, openldap, readline, sqlite, zlib
, enableMinimal ? false
, withPcsc ? !enableMinimal, pcsclite
, guiSupport ? stdenv.isDarwin, pinentry
}:

assert guiSupport -> enableMinimal == false;

stdenv.mkDerivation rec {
  pname = "gnupg";
  version = "2.2.41";

  src = fetchurl {
    url = "mirror://gnupg/gnupg/${pname}-${version}.tar.bz2";
    hash = "sha256-E/MpEAel6FRvy3vAxmEM5EqqmzmVBZ1PgUW6Cf1b4+E=";
  };

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ pkg-config texinfo ];
  buildInputs = [
    gettext libassuan libgcrypt libgpg-error libiconv libksba npth
  ] ++ lib.optionals (!enableMinimal) [
    adns bzip2 gnutls libusb1 openldap readline sqlite zlib
  ];

  patches = [
    ./fix-libusb-include-path.patch
    ./tests-add-test-cases-for-import-without-uid.patch
    ./accept-subkeys-with-a-good-revocation-but-no-self-sig.patch
    ./22-allow-import-of-previously-known-keys-even-without-UI.patch
  ];

  postPatch = ''
    sed -i 's,hkps://hkps.pool.sks-keyservers.net,hkps://keys.openpgp.org,g' configure doc/dirmngr.texi doc/gnupg.info-1
    # Fix broken SOURCE_DATE_EPOCH usage - remove on the next upstream update
    sed -i 's/$SOURCE_DATE_EPOCH/''${SOURCE_DATE_EPOCH}/' doc/Makefile.am
    sed -i 's/$SOURCE_DATE_EPOCH/''${SOURCE_DATE_EPOCH}/' doc/Makefile.in
    '' + lib.optionalString (stdenv.isLinux && withPcsc) ''
      sed -i 's,"libpcsclite\.so[^"]*","${lib.getLib pcsclite}/lib/libpcsclite.so",g' scd/scdaemon.c
    '';

  configureFlags = [
    "--with-libgpg-error-prefix=${libgpg-error.dev}"
    "--with-libgcrypt-prefix=${libgcrypt.dev}"
    "--with-libassuan-prefix=${libassuan.dev}"
    "--with-ksba-prefix=${libksba.dev}"
    "--with-npth-prefix=${npth}"
  ]
  ++ lib.optional guiSupport "--with-pinentry-pgm=${pinentry}/${pinentry.binaryPath or "bin/pinentry"}"
  ++ lib.optional stdenv.isDarwin "--disable-ccid-driver";

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

    ln -s -t $out/bin $out/libexec/*
  '';

  enableParallelBuilding = true;

  passthru.tests = lib.nixosTests.gnupg;

  meta = with lib; {
    homepage = "https://gnupg.org";
    changelog = "https://git.gnupg.org/cgi-bin/gitweb.cgi?p=${pname}.git;a=blob;f=NEWS;hb=refs/tags/${pname}-${version}";
    description = "LTS release of the GNU Privacy Guard, a GPL OpenPGP implementation";
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
