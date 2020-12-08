{ stdenv
, fetchurl
, fetchpatch
, zlib
, openssl
, libedit
, pkgconfig
, pam
, autoreconfHook
, etcDir ? null
, hpnSupport ? false
, withKerberos ? true
, withGssapiPatches ? false
, kerberos
, libfido2
, withFIDO ? stdenv.hostPlatform.isUnix && !stdenv.hostPlatform.isMusl
, linkOpenssl ? true
}:

let

  version = "8.4p1";

  # **please** update this patch when you update to a new openssh release.
  gssapiPatch = fetchpatch {
    name = "openssh-gssapi.patch";
    url = "https://salsa.debian.org/ssh-team/openssh/raw/debian/1%25${version}-2/debian/patches/gssapi.patch";
    sha256 = "1z1ckzimlkm1dmr9f5fqjnjg28gsqcwx6xka0klak857548d2lp2";
  };

in
with stdenv.lib;
stdenv.mkDerivation rec {
  pname = "openssh";
  inherit version;

  src = if hpnSupport then
      fetchurl {
        url = "https://github.com/rapier1/openssh-portable/archive/hpn-KitchenSink-${replaceStrings [ "." "p" ] [ "_" "_P" ] version}.tar.gz";
        sha256 = "1x2afjy1isslbg7qlvhhs4zhj2c8q2h1ljz0fc5b4h9pqcm9j540";
      }
    else
      fetchurl {
        url = "mirror://openbsd/OpenSSH/portable/${pname}-${version}.tar.gz";
        sha256 = "091b3pxdlj47scxx6kkf4agkx8c8sdacdxx8m1dw1cby80pd40as";
      };

  patches =
    [
      ./locale_archive.patch

      # See discussion in https://github.com/NixOS/nixpkgs/pull/16966
      ./dont_create_privsep_path.patch

      ./ssh-keysign.patch

      # See https://github.com/openssh/openssh-portable/pull/206
      ./ssh-copy-id-fix-eof.patch
    ]
    ++ optional withGssapiPatches (assert withKerberos; gssapiPatch);

  postPatch =
    # On Hydra this makes installation fail (sometimes?),
    # and nix store doesn't allow such fancy permission bits anyway.
    ''
      substituteInPlace Makefile.in --replace '$(INSTALL) -m 4711' '$(INSTALL) -m 0711'
    '';

  nativeBuildInputs = [ pkgconfig ]
    ++ optional (hpnSupport || withGssapiPatches) autoreconfHook
    ++ optional withKerberos kerberos.dev;
  buildInputs = [ zlib openssl libedit pam ]
    ++ optional withFIDO libfido2
    ++ optional withKerberos kerberos;

  preConfigure = ''
    # Setting LD causes `configure' and `make' to disagree about which linker
    # to use: `configure' wants `gcc', but `make' wants `ld'.
    unset LD
  ''
  # Upstream build system does not support static build, so we fall back
  # on fragile patching of configure script.
  #
  # libedit is found by pkgconfig, but without --static flag, required
  # to get also transitive dependencies for static linkage, hence sed
  # expression.
  #
  # Kerberos can be found either by krb5-config or by fall-back shell
  # code in openssh's configure.ac. Neither of them support static
  # build, but patching code for krb5-config is simpler, so to get it
  # into PATH, kerberos.dev is added into buildInputs.
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
    (if pam != null then "--with-pam" else "--without-pam")
  ] ++ optional (etcDir != null) "--sysconfdir=${etcDir}"
    ++ optional withFIDO "--with-security-key-builtin=yes"
    ++ optional withKerberos (assert kerberos != null; "--with-kerberos5=${kerberos}")
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

  meta = {
    description = "An implementation of the SSH protocol";
    homepage = "https://www.openssh.com/";
    changelog = "https://www.openssh.com/releasenotes.html";
    license = stdenv.lib.licenses.bsd2;
    platforms = platforms.unix ++ platforms.windows;
    maintainers = with maintainers; [ eelco aneeshusa ];
  };
}
