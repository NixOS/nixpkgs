{ fetchurl, fetchpatch, stdenv, pkgconfig, libgcrypt, libassuan, libksba
, libgpgerror, libiconv, npth, gettext, texinfo, buildPackages

# Each of the dependencies below are optional.
# Gnupg can be built without them at the cost of reduced functionality.
, guiSupport ? true, enableMinimal ? false
, adns ? null , bzip2 ? null , gnutls ? null , libusb1 ? null , openldap ? null
, pcsclite ? null , pinentry ? null , readline ? null , sqlite ? null , zlib ?
null
}:

with stdenv.lib;

assert guiSupport -> pinentry != null && enableMinimal == false;

stdenv.mkDerivation rec {
  pname = "gnupg";

  version = "2.2.25";

  src = fetchurl {
    url = "mirror://gnupg/gnupg/${pname}-${version}.tar.bz2";
    sha256 = "02n3klqbyzxyil13sg4wa0pcwr7vs7zjaslis926yjxg8yr0fly5";
  };

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ pkgconfig texinfo ];
  buildInputs = [
    libgcrypt libassuan libksba libiconv npth gettext
    readline libusb1 gnutls adns openldap zlib bzip2 sqlite
  ];

  patches = [
    ./fix-libusb-include-path.patch
    ./0001-dirmngr-Only-use-SKS-pool-CA-for-SKS-pool.patch
    ./tests-add-test-cases-for-import-without-uid.patch
    ./allow-import-of-previously-known-keys-even-without-UI.patch
    ./accept-subkeys-with-a-good-revocation-but-no-self-sig.patch
  ];
  postPatch = ''
    sed -i 's,hkps://hkps.pool.sks-keyservers.net,hkps://keys.openpgp.org,g' configure doc/dirmngr.texi doc/gnupg.info-1
    # Fix broken SOURCE_DATE_EPOCH usage - remove on the next upstream update
    sed -i 's/$SOURCE_DATE_EPOCH/''${SOURCE_DATE_EPOCH}/' doc/Makefile.am
    sed -i 's/$SOURCE_DATE_EPOCH/''${SOURCE_DATE_EPOCH}/' doc/Makefile.in
  '' + stdenv.lib.optionalString ( stdenv.isLinux && pcsclite != null) ''
    sed -i 's,"libpcsclite\.so[^"]*","${stdenv.lib.getLib pcsclite}/lib/libpcsclite.so",g' scd/scdaemon.c
  ''; #" fix Emacs syntax highlighting :-(

  pinentryBinaryPath = pinentry.binaryPath or "bin/pinentry";
  configureFlags = [
    "--with-libgpg-error-prefix=${libgpgerror.dev}"
    "--with-libgcrypt-prefix=${libgcrypt.dev}"
    "--with-libassuan-prefix=${libassuan.dev}"
    "--with-ksba-prefix=${libksba.dev}"
    "--with-npth-prefix=${npth}"
  ] ++ optional guiSupport "--with-pinentry-pgm=${pinentry}/${pinentryBinaryPath}";

  postInstall = if enableMinimal
  then ''
    rm -r $out/{libexec,sbin,share}
    for f in `find $out/bin -type f -not -name gpg`
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
    ln -s -t $out/bin $out/libexec/*
  '';

  meta = with stdenv.lib; {
    homepage = "https://gnupg.org";
    description = "Modern (2.1) release of the GNU Privacy Guard, a GPL OpenPGP implementation";
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
    maintainers = with maintainers; [ peti fpletz vrthra ];
    platforms = platforms.all;
  };
}
