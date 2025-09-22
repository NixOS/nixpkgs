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
  openssh,
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
  version = "2.4.8";

  src = fetchurl {
    url = "mirror://gnupg/gnupg/${pname}-${version}.tar.bz2";
    hash = "sha256-tYyA15sE0yQ/9JwcP8a1+DE46zeEaJVjvN0GBZUxhhY=";
  };

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [
    # XXX: do not add autoreconfHook without very careful testing!
    # Problems that were identified during the last attempt:
    #  • Prints a warning about being a development version not
    #    suitable for production use.
    #  • Smartcards do not work, at least without pcscd.

    pkg-config
    texinfo
    libgpg-error
  ];
  buildInputs = [
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

  # FreePG (https://freepg.org) is a set of commonly-used patches for GnuPG that
  # have not been merged upstream. It is used by Arch Linux, Debian, Fedora and
  # NixOS, and is maintained by Andrew Gallagher.
  #
  # The main purpose of including these patches in Nixpkgs is to maintain
  # compatibility with OpenPGP.
  #
  freepgPatches = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "freepg";
    repo = "gnupg";
    rev = "361c223eb00ca372fbf9506f5150ddbec193936f";
    hash = "sha256-hRuwrB6G2vjp7Md6m+cwoi7g4GtW0sazAEN5RC+AKdg=";
  };

  patches = [
    # Without this, scdaemon isn't linked to libusb, causing smartcards to not work correctly
    ./fix-libusb-include-path.patch
    # Use pkg-config to find tss2-esys to fix static building
    # Submitted upstream: https://dev.gnupg.org/D606
    # The diff is larger than upstream because configure.ac was modified,
    # requiring configure to be regenerated. For reasons we don't totally
    # understand, regenerating configure has all sorts of other undesirable
    # side effects. So to unbreak things, instead of regenerating configure,
    # we can include just the configure changes relevant to the static patch
    # in the patch file.
    ./static.patch
  ]
  ++ lib.map (v: "${freepgPatches}/STABLE-BRANCH-2-4-freepg/" + v) [
    "0002-gpg-accept-subkeys-with-a-good-revocation-but-no-sel.patch"
    "0003-gpg-allow-import-of-previously-known-keys-even-witho.patch"
    "0004-tests-add-test-cases-for-import-without-uid.patch"
    "0005-gpg-drop-import-clean-from-default-keyserver-import-.patch"
    "0008-avoid-systemd-deprecation-warning.patch"
    "0009-Add-systemd-support-for-keyboxd.patch"
    "0010-Ship-sample-systemd-unit-files.patch"
    "0011-el-gamal-default-to-3072-bits.patch"
    "0012-gpg-default-digest-algorithm-SHA512.patch"
    "0013-gpg-Prefer-SHA-512-and-SHA-384-in-personal-digest.patch"
    "0018-Avoid-simple-memory-dumps-via-ptrace.patch"
    "0019-Disallow-compressed-signatures-and-certificates.patch"
    "0020-ssh-agent-emulation-under-systemd-inject-SSH_AUTH_SO.patch"
    "0021-gpg-Sync-compliance-mode-cleanup-with-master.patch"
    "0022-gpg-emit-RSA-pubkey-algorithm-when-in-compatibility-.patch"
    "0023-gpg-Reintroduce-openpgp-as-distinct-from-rfc4880.patch"
    "0024-gpg-Emit-LibrePGP-material-only-in-compliance-gnupg.patch"
    "0025-gpg-gpgconf-list-report-actual-compliance-mode.patch"
    "0026-gpg-Default-to-compliance-openpgp.patch"
    "0027-gpg-Fix-newlines-in-Cleartext-Signature-Framework-CS.patch"
    "0029-Add-keyboxd-systemd-support.patch"
    "0033-Support-large-RSA-keygen-in-non-batch-mode.patch"
    "0034-gpg-Verify-Text-mode-Signatures-over-binary-Literal-.patch"
  ];

  postPatch =
    # Switch the default key server to keys.openpgp.org
    # The original motivation in 2019 was to switch away from the then-default SKS network: https://github.com/NixOS/nixpkgs/pull/63952
    # In 2021 upstream also switched away, but to keyserver.ubuntu.com: https://dev.gnupg.org/rG47c4e3e00a7ef55f954c14b3c237496e54a853c1,
    # while NixOS kept the keys.openpgp.org default: https://github.com/NixOS/nixpkgs/pull/159604
    # TODO: Should this patch be removed so that the now-uncompromised default is used once again?
    # A significant difference between the two seems to be that keys.openpgp.org is verifying keys, while keyserver.ubuntu.com isn't: https://unix.stackexchange.com/a/694528
    # The keys.openpgp.org also has a great FAQ: https://keys.openpgp.org/about/faq
    ''
      sed -i 's,\(hkps\|https\)://keyserver.ubuntu.com,hkps://keys.openpgp.org,g' configure configure.ac doc/dirmngr.texi doc/gnupg.info-1
    ''
    + lib.optionalString (stdenv.hostPlatform.isLinux && withPcsc) ''
      sed -i 's,"libpcsclite\.so[^"]*","${lib.getLib pcsclite}/lib/libpcsclite.so",g' scd/scdaemon.c
    '';

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-Wno-implicit-function-declaration";

  configureFlags = [
    "--sysconfdir=/etc"
    # Needed for large RSA key support (patch 0033)
    "--enable-large-secmem"
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
        for f in $out/libexec/*; do
          if [[ "$(basename $f)" == "gpg-wks-client" ]]; then continue; fi
          ln -s $f $out/bin/$(basename $f)
        done
      '';

  enableParallelBuilding = true;

  nativeCheckInputs = [
    # A test would be skipped without SSH
    openssh
  ];
  doCheck = !enableMinimal;

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
