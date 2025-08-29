{
  pname,
  version,
  extraDesc ? "",
  src,
  extraPatches ? [ ],
  extraNativeBuildInputs ? [ ],
  extraConfigureFlags ? [ ],
  extraMeta ? { },
}:

{
  lib,
  stdenv,
  # This *is* correct, though unusual. as a way of getting krb5-config from the
  # package without splicing See: https://github.com/NixOS/nixpkgs/pull/107606
  pkgs,
  fetchurl,
  fetchpatch,
  autoreconfHook,
  zlib,
  openssl,
  softhsm,
  libedit,
  ldns,
  pkg-config,
  pam,
  libredirect,
  etcDir ? null,
  withKerberos ? false,
  withLdns ? true,
  krb5,
  libfido2,
  libxcrypt,
  hostname,
  nixosTests,
  withSecurityKey ? !stdenv.hostPlatform.isStatic,
  withFIDO ? stdenv.hostPlatform.isUnix && !stdenv.hostPlatform.isMusl && withSecurityKey,
  withPAM ? stdenv.hostPlatform.isLinux,
  # Attempts to mlock the entire sshd process on startup to prevent swapping.
  # Currently disabled when PAM support is enabled due to crashes
  # See https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1103418
  withLinuxMemlock ? (stdenv.hostPlatform.isLinux && !withPAM),
  linkOpenssl ? true,
  isNixos ? stdenv.hostPlatform.isLinux,
}:

# FIDO support requires SK support
assert withFIDO -> withSecurityKey;

stdenv.mkDerivation (finalAttrs: {
  inherit pname version src;

  patches = [
    # Making openssh pass the LOCALE_ARCHIVE variable to the forked session processes,
    # so the session 'bash' will receive the proper locale archive, and thus process
    # UTF-8 properly.
    ./locale_archive.patch

    # See discussion in https://github.com/NixOS/nixpkgs/pull/16966
    ./dont_create_privsep_path.patch
  ]
  ++ extraPatches;

  postPatch =
    # On Hydra this makes installation fail (sometimes?),
    # and nix store doesn't allow such fancy permission bits anyway.
    ''
      substituteInPlace Makefile.in --replace '$(INSTALL) -m 4711' '$(INSTALL) -m 0711'
    '';

  strictDeps = true;
  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ]
  # This is not the same as the krb5 from the inputs! pkgs.krb5 is
  # needed here to access krb5-config in order to cross compile. See:
  # https://github.com/NixOS/nixpkgs/pull/107606
  ++ lib.optional withKerberos pkgs.krb5
  ++ extraNativeBuildInputs;
  buildInputs = [
    zlib
    libedit
  ]
  ++ [ (if linkOpenssl then openssl else libxcrypt) ]
  ++ lib.optional withFIDO libfido2
  ++ lib.optional withKerberos krb5
  ++ lib.optional withLdns ldns
  ++ lib.optional withPAM pam;

  preConfigure = ''
    # Setting LD causes `configure' and `make' to disagree about which linker
    # to use: `configure' wants `gcc', but `make' wants `ld'.
    unset LD
  '';

  env = lib.optionalAttrs isNixos {
    # openssh calls passwd to allow the user to reset an expired password, but nixos
    # doesn't ship it at /usr/bin/passwd.
    PATH_PASSWD_PROG = "/run/wrappers/bin/passwd";
  };

  # I set --disable-strip because later we strip anyway. And it fails to strip
  # properly when cross building.
  configureFlags = [
    "--sbindir=\${out}/bin"
    "--localstatedir=/var"
    "--with-pid-dir=/run"
    "--with-mantype=doc"
    "--with-libedit=yes"
    "--disable-strip"
    (lib.withFeature withPAM "pam")
  ]
  ++ lib.optional (etcDir != null) "--sysconfdir=${etcDir}"
  ++ lib.optional (!withSecurityKey) "--disable-security-key"
  ++ lib.optional withFIDO "--with-security-key-builtin=yes"
  ++ lib.optional withKerberos (
    assert krb5 != null;
    "--with-kerberos5=${lib.getDev krb5}"
  )
  ++ lib.optional stdenv.hostPlatform.isDarwin "--disable-libutil"
  ++ lib.optional (!linkOpenssl) "--without-openssl"
  ++ lib.optional withLdns "--with-ldns"
  ++ lib.optional stdenv.hostPlatform.isOpenBSD "--with-bsd-auth"
  ++ lib.optional withLinuxMemlock "--with-linux-memlock-onfault"
  ++ extraConfigureFlags;

  ${if stdenv.hostPlatform.isStatic then "NIX_LDFLAGS" else null} = [
    "-laudit"
  ]
  ++ lib.optional withKerberos "-lkeyutils"
  ++ lib.optional withLdns "-lcrypto";

  buildFlags = [ "SSH_KEYSIGN=ssh-keysign" ];

  enableParallelBuilding = true;

  hardeningEnable = [ "pie" ];

  doCheck = false;
  enableParallelChecking = false;
  nativeCheckInputs = [
    openssl
  ]
  ++ lib.optional (!stdenv.hostPlatform.isDarwin) hostname
  ++ lib.optional (!stdenv.hostPlatform.isDarwin && !stdenv.hostPlatform.isMusl) softhsm;

  preCheck = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) (
    ''
      # construct a dummy HOME
      export HOME=$(realpath ../dummy-home)
      mkdir -p ~/.ssh

      # construct a dummy /etc/passwd file for the sshd under test
      # to use to look up the connecting user
      DUMMY_PASSWD=$(realpath ../dummy-passwd)
      cat > $DUMMY_PASSWD <<EOF
      $(whoami)::$(id -u):$(id -g)::$HOME:$SHELL
      EOF

      # we need to NIX_REDIRECTS /etc/passwd both for processes
      # invoked directly and those invoked by the "remote" session
      cat > ~/.ssh/environment.base <<EOF
      NIX_REDIRECTS=/etc/passwd=$DUMMY_PASSWD
      ${lib.optionalString (
        !stdenv.buildPlatform.isStatic
      ) "LD_PRELOAD=${libredirect}/lib/libredirect.so"}
      EOF

      # use an ssh environment file to ensure environment is set
      # up appropriately for build environment even when no shell
      # is invoked by the ssh session. otherwise the PATH will
      # only contain default unix paths like /bin which we don't
      # have in our build environment
      cat - regress/test-exec.sh > regress/test-exec.sh.new <<EOF
      cp $HOME/.ssh/environment.base $HOME/.ssh/environment
      echo "PATH=\$PATH" >> $HOME/.ssh/environment
      EOF
      mv regress/test-exec.sh.new regress/test-exec.sh

      # explicitly enable the PermitUserEnvironment feature
      substituteInPlace regress/test-exec.sh \
        --replace \
          'cat << EOF > $OBJ/sshd_config' \
          $'cat << EOF > $OBJ/sshd_config\n\tPermitUserEnvironment yes'

      # some tests want to use files under /bin as example files
      for f in regress/sftp-cmds.sh regress/forwarding.sh; do
        substituteInPlace $f --replace '/bin' "$(dirname $(type -p ls))"
      done

      # set up NIX_REDIRECTS for direct invocations
      set -a; source ~/.ssh/environment.base; set +a
    ''
    + lib.optionalString (!stdenv.hostPlatform.isDarwin && !stdenv.hostPlatform.isMusl) ''
      # The extra tests check PKCS#11 interactions, which softhsm emulates with software only
      substituteInPlace regress/test-exec.sh \
        --replace /usr/local/lib/softhsm/libsofthsm2.so ${lib.getLib softhsm}/lib/softhsm/libsofthsm2.so
    ''
  );
  # integration tests hard to get working on darwin with its shaky
  # sandbox
  # t-exec tests fail on musl
  checkTarget =
    lib.optionals (!stdenv.hostPlatform.isDarwin && !stdenv.hostPlatform.isMusl) [
      "t-exec"
      "extra-tests"
    ]
    # other tests are less demanding of the environment
    ++ [
      "unit"
      "file-tests"
      "interop-tests"
    ];

  postInstall = ''
    # Install ssh-copy-id, it's very useful.
    cp contrib/ssh-copy-id $out/bin/
    chmod +x $out/bin/ssh-copy-id
    cp contrib/ssh-copy-id.1 $out/share/man/man1/
  '';

  installTargets = [ "install-nokeys" ];
  installFlags = [
    "sysconfdir=\${out}/etc/ssh"
  ];

  doInstallCheck = true;
  installCheckPhase = ''
    for binary in ssh sshd; do
      $out/bin/$binary -V 2>&1 | grep -P "$(printf '^OpenSSH_\\Q%s\\E,' "$version")"
    done
  '';

  passthru = {
    inherit withKerberos;
    tests = {
      borgbackup-integration = nixosTests.borgbackup;
      nixosTest = nixosTests.openssh;
      initrd-network-openssh = nixosTests.initrd-network-ssh;
      openssh = finalAttrs.finalPackage.overrideAttrs (previousAttrs: {
        pname = previousAttrs.pname + "-test";
        doCheck = true;
      });
    };
  };

  meta = {
    description = "Implementation of the SSH protocol${extraDesc}";
    homepage = "https://www.openssh.com/";
    changelog = "https://www.openssh.com/releasenotes.html";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    maintainers = extraMeta.maintainers or [ ];
    mainProgram = "ssh";
  }
  // extraMeta;
})
