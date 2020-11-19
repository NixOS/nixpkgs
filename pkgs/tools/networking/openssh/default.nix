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
        sha256 = "06mr2q8d9kbj145r7mzmpm3a4ilnssibwlbjyy0bjsqrqnrll3zl";
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

  nativeBuildInputs = [ pkgconfig ] ++ optional (hpnSupport || withGssapiPatches) autoreconfHook;
  buildInputs = [ zlib openssl libedit pam ]
    ++ optional withFIDO libfido2
    ++ optional withKerberos kerberos;

  preConfigure = ''
    # Setting LD causes `configure' and `make' to disagree about which linker
    # to use: `configure' wants `gcc', but `make' wants `ld'.
    unset LD
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
