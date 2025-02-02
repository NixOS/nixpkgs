{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitLab,
  buildPackages,
  pkg-config,
  texinfo,
  gettext,
  libassuan,
  libgcrypt,
  libgpg-error,
  libiconv,
  libksba,
  npth,
  adns,
  bzip2,
  gnutls,
  libusb1,
  openldap,
  readline,
  sqlite,
  zlib,
  enableMinimal ? false,
  withPcsc ? !enableMinimal,
  pcsclite,
  guiSupport ? stdenv.hostPlatform.isDarwin,
  pinentry,
  withTpm2Tss ? !stdenv.hostPlatform.isDarwin && !enableMinimal,
  tpm2-tss,
  nixosTests,
}:

assert guiSupport -> !enableMinimal;

stdenv.mkDerivation rec {
  pname = "gnupg";
  version = "2.4.7";

  src = fetchurl {
    url = "mirror://gnupg/gnupg/${pname}-${version}.tar.bz2";
    hash = "sha256-eyRwbk2n4OOwbKBoIxAnQB8jgQLEHJCWMTSdzDuF60Y=";
  };

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [
    pkg-config
    texinfo
    libgpg-error
  ];
  buildInputs =
    [
      gettext
      libassuan
      libgcrypt
      libgpg-error
      libiconv
      libksba
      npth
    ]
    ++ lib.optionals (!enableMinimal) [
      adns
      bzip2
      gnutls
      libusb1
      openldap
      readline
      sqlite
      zlib
    ]
    ++ lib.optionals withTpm2Tss [ tpm2-tss ];

  freepgPatches = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "freepg";
    repo = "gnupg";
    rev = "541772915dc4ec832c37f85bc629a22051f0e8f7";
    hash = "sha256-QOUY6EfJbTTN242BtzLojDgECGjUwbLfPJgzn/mj5L8=";
  };

  patches =
    [
      ./fix-libusb-include-path.patch
      ./CVE-2022-3219.patch
    ]
    ++ lib.map (v: "${freepgPatches}/STABLE-BRANCH-2-4-freepg/" + v) [
      "0002-gpg-accept-subkeys-with-a-good-revocation-but-no-sel.patch"
      "0003-gpg-allow-import-of-previously-known-keys-even-witho.patch"
      "0004-tests-add-test-cases-for-import-without-uid.patch"
      "0005-gpg-drop-import-clean-from-default-keyserver-import-.patch"
      "0006-Do-not-use-OCB-mode-even-if-AEAD-OCB-key-preference-.patch"
      "0007-Revert-the-introduction-of-the-RFC4880bis-draft-into.patch"
      "0008-avoid-systemd-deprecation-warning.patch"
      "0009-Add-systemd-support-for-keyboxd.patch"
      "0010-doc-Remove-profile-and-systemd-example-files.patch"
    ];

  postPatch =
    ''
      sed -i 's,\(hkps\|https\)://keyserver.ubuntu.com,hkps://keys.openpgp.org,g' configure configure.ac doc/dirmngr.texi doc/gnupg.info-1
    ''
    + lib.optionalString (stdenv.hostPlatform.isLinux && withPcsc) ''
      sed -i 's,"libpcsclite\.so[^"]*","${lib.getLib pcsclite}/lib/libpcsclite.so",g' scd/scdaemon.c
    '';

  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-Wno-implicit-function-declaration";

  configureFlags =
    [
      "--sysconfdir=/etc"
      "--with-libgpg-error-prefix=${libgpg-error.dev}"
      "--with-libgcrypt-prefix=${libgcrypt.dev}"
      "--with-libassuan-prefix=${libassuan.dev}"
      "--with-ksba-prefix=${libksba.dev}"
      "GPGRT_CONFIG=${lib.getDev libgpg-error}/bin/gpgrt-config"
    ]
    ++ lib.optional guiSupport "--with-pinentry-pgm=${pinentry}/${
      pinentry.binaryPath or "bin/pinentry"
    }"
    ++ lib.optional withTpm2Tss "--with-tss=intel"
    ++ lib.optional stdenv.hostPlatform.isDarwin "--disable-ccid-driver";

  postInstall =
    if enableMinimal then
      ''
        rm -r $out/{libexec,sbin,share}
        for f in $(find $out/bin -type f -not -name gpg)
        do
          rm $f
        done
      ''
    else
      ''
        # add gpg2 symlink to make sure git does not break when signing commits
        ln -s $out/bin/gpg $out/bin/gpg2

        # Make libexec tools available in PATH
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
    maintainers = with maintainers; [
      fpletz
      sgo
    ];
    platforms = platforms.all;
    mainProgram = "gpg";
  };
}
