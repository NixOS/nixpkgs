{ pname
, version
, extraDesc ? ""
, src
, extraPatches ? []
, extraNativeBuildInputs ? []
, extraMeta ? {}
}:

{ lib, stdenv
# This *is* correct, though unusual. as a way of getting krb5-config from the
# package without splicing See: https://github.com/NixOS/nixpkgs/pull/107606
, pkgs
, fetchurl
, fetchpatch
, zlib
, openssl
, libedit
, pkg-config
, pam
, etcDir ? null
, withKerberos ? !(stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64)
, libkrb5
, libfido2
, nixosTests
, withFIDO ? stdenv.hostPlatform.isUnix && !stdenv.hostPlatform.isMusl
, linkOpenssl ? true
}:

with lib;
stdenv.mkDerivation rec {
  inherit pname version src;

  patches = [
    ./locale_archive.patch

    # See discussion in https://github.com/NixOS/nixpkgs/pull/16966
    ./dont_create_privsep_path.patch
  ] ++ extraPatches;

  postPatch =
    # On Hydra this makes installation fail (sometimes?),
    # and nix store doesn't allow such fancy permission bits anyway.
    ''
      substituteInPlace Makefile.in --replace '$(INSTALL) -m 4711' '$(INSTALL) -m 0711'
    '';

  nativeBuildInputs = [ pkg-config ]
    # This is not the same as the libkrb5 from the inputs! pkgs.libkrb5 is
    # needed here to access krb5-config in order to cross compile. See:
    # https://github.com/NixOS/nixpkgs/pull/107606
    ++ optional withKerberos pkgs.libkrb5
    ++ extraNativeBuildInputs;
  buildInputs = [ zlib openssl libedit ]
    ++ optional withFIDO libfido2
    ++ optional withKerberos libkrb5
    ++ optional stdenv.isLinux pam;

  preConfigure = ''
    # Setting LD causes `configure' and `make' to disagree about which linker
    # to use: `configure' wants `gcc', but `make' wants `ld'.
    unset LD
  ''
  # Upstream build system does not support static build, so we fall back
  # on fragile patching of configure script.
  #
  # libedit is found by pkg-config, but without --static flag, required
  # to get also transitive dependencies for static linkage, hence sed
  # expression.
  #
  # Kerberos can be found either by krb5-config or by fall-back shell
  # code in openssh's configure.ac. Neither of them support static
  # build, but patching code for krb5-config is simpler, so to get it
  # into PATH, libkrb5.dev is added into buildInputs.
  + optionalString stdenv.hostPlatform.isStatic ''
    sed -i "s,PKGCONFIG --libs,PKGCONFIG --libs --static,g" configure
    sed -i 's#KRB5CONF --libs`#KRB5CONF --libs` -lkrb5support -lkeyutils#g' configure
    sed -i 's#KRB5CONF --libs gssapi`#KRB5CONF --libs gssapi` -lkrb5support -lkeyutils#g' configure
  '';

  # I set --disable-strip because later we strip anyway. And it fails to strip
  # properly when cross building.
  configureFlags = [
    "--sbindir=\${out}/bin"
    "--localstatedir=/var"
    "--with-pid-dir=/run"
    "--with-mantype=man"
    "--with-libedit=yes"
    "--disable-strip"
    (if stdenv.isLinux then "--with-pam" else "--without-pam")
  ] ++ optional (etcDir != null) "--sysconfdir=${etcDir}"
    ++ optional withFIDO "--with-security-key-builtin=yes"
    ++ optional withKerberos (assert libkrb5 != null; "--with-kerberos5=${libkrb5}")
    ++ optional stdenv.isDarwin "--disable-libutil"
    ++ optional (!linkOpenssl) "--without-openssl";

  buildFlags = [ "SSH_KEYSIGN=ssh-keysign" ];

  enableParallelBuilding = true;

  hardeningEnable = [ "pie" ];

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

  passthru.tests = {
    borgbackup-integration = nixosTests.borgbackup;
  };

  meta = {
    description = "An implementation of the SSH protocol${extraDesc}";
    homepage = "https://www.openssh.com/";
    changelog = "https://www.openssh.com/releasenotes.html";
    license = licenses.bsd2;
    platforms = platforms.unix ++ platforms.windows;
    maintainers = (extraMeta.maintainers or []) ++ (with maintainers; [ eelco aneeshusa ]);
    mainProgram = "ssh";
  } // extraMeta;
}
