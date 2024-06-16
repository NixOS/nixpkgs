{ pname
, version
, extraDesc ? ""
, src
, extraPatches ? []
, extraNativeBuildInputs ? []
, extraConfigureFlags ? []
, extraMeta ? {}
}:

{ lib, stdenv
# This *is* correct, though unusual. as a way of getting krb5-config from the
# package without splicing See: https://github.com/NixOS/nixpkgs/pull/107606
, pkgs
, fetchurl
, autoreconfHook
, zlib
, openssl
, libedit
, ldns
, pkg-config
, pam
, libredirect
, etcDir ? null
, withKerberos ? false
, withLdns ? true
, libkrb5
, libfido2
, libxcrypt
, hostname
, nixosTests
, withFIDO ? stdenv.hostPlatform.isUnix && !stdenv.hostPlatform.isMusl
, withPAM ? stdenv.hostPlatform.isLinux
, dsaKeysSupport ? false
, linkOpenssl ? true
, isNixos ? stdenv.hostPlatform.isLinux
}:

stdenv.mkDerivation {
  inherit pname version src;

  patches = [
    ./locale_archive.patch

    (fetchurl {
      url = "https://git.alpinelinux.org/aports/plain/main/openssh/gss-serv.c.patch?id=a7509603971ce2f3282486a43bb773b1b522af83";
      sha256 = "sha256-eFFOd4B2nccRZAQWwdBPBoKWjfEdKEVGJvKZAzLu3HU=";
    })

    # See discussion in https://github.com/NixOS/nixpkgs/pull/16966
    ./dont_create_privsep_path.patch
  ] ++ extraPatches;

  postPatch =
    # On Hydra this makes installation fail (sometimes?),
    # and nix store doesn't allow such fancy permission bits anyway.
    ''
      substituteInPlace Makefile.in --replace '$(INSTALL) -m 4711' '$(INSTALL) -m 0711'
    '';

  strictDeps = true;
  nativeBuildInputs = [ autoreconfHook pkg-config ]
    # This is not the same as the libkrb5 from the inputs! pkgs.libkrb5 is
    # needed here to access krb5-config in order to cross compile. See:
    # https://github.com/NixOS/nixpkgs/pull/107606
    ++ lib.optional withKerberos pkgs.libkrb5
    ++ extraNativeBuildInputs;
  buildInputs = [ zlib libedit ]
    ++ [ (if linkOpenssl then openssl else libxcrypt) ]
    ++ lib.optional withFIDO libfido2
    ++ lib.optional withKerberos libkrb5
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
    "--with-mantype=man"
    "--with-libedit=yes"
    "--disable-strip"
    (lib.withFeature withPAM "pam")
    (lib.enableFeature dsaKeysSupport "dsa-keys")
  ] ++ lib.optional (etcDir != null) "--sysconfdir=${etcDir}"
    ++ lib.optional withFIDO "--with-security-key-builtin=yes"
    ++ lib.optional withKerberos (assert libkrb5 != null; "--with-kerberos5=${libkrb5}")
    ++ lib.optional stdenv.isDarwin "--disable-libutil"
    ++ lib.optional (!linkOpenssl) "--without-openssl"
    ++ lib.optional withLdns "--with-ldns"
    ++ extraConfigureFlags;

  ${if stdenv.hostPlatform.isStatic then "NIX_LDFLAGS" else null}= [ "-laudit" ] ++ lib.optionals withKerberos [ "-lkeyutils" ];

  buildFlags = [ "SSH_KEYSIGN=ssh-keysign" ];

  enableParallelBuilding = true;

  hardeningEnable = [ "pie" ];

  doCheck = true;
  enableParallelChecking = false;
  nativeCheckInputs = [ openssl ] ++ lib.optional (!stdenv.isDarwin) hostname;
  preCheck = lib.optionalString (stdenv.hostPlatform == stdenv.buildPlatform) ''
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
    LD_PRELOAD=${libredirect}/lib/libredirect.so
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
  '';
  # integration tests hard to get working on darwin with its shaky
  # sandbox
  # t-exec tests fail on musl
  checkTarget = lib.optional (!stdenv.isDarwin && !stdenv.hostPlatform.isMusl) "t-exec"
    # other tests are less demanding of the environment
    ++ [ "unit" "file-tests" "interop-tests" ];

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

  passthru = {
    inherit withKerberos;
    tests = {
      borgbackup-integration = nixosTests.borgbackup;
      openssh = nixosTests.openssh;
    };
  };

  meta = with lib; {
    description = "An implementation of the SSH protocol${extraDesc}";
    homepage = "https://www.openssh.com/";
    changelog = "https://www.openssh.com/releasenotes.html";
    license = licenses.bsd2;
    platforms = platforms.unix ++ platforms.windows;
    maintainers = (extraMeta.maintainers or []) ++ (with maintainers; [ eelco aneeshusa ]);
    mainProgram = "ssh";
  } // extraMeta;
}
