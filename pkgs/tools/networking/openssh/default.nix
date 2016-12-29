{ stdenv, fetchurl, fetchpatch, zlib, openssl, perl, libedit, pkgconfig, pam
, etcDir ? null
, hpnSupport ? false
, withKerberos ? false
, withGssapiPatches ? false
, kerberos
, linkOpenssl? true
}:

assert withKerberos -> kerberos != null;
assert withGssapiPatches -> withKerberos;

let

  hpnSrc = fetchurl {
    url = mirror://sourceforge/hpnssh/openssh-6.6p1-hpnssh14v5.diff.gz;
    sha256 = "682b4a6880d224ee0b7447241b684330b731018585f1ba519f46660c10d63950";
  };

  # **please** update this patch when you update to a new openssh release.
  gssapiSrc = fetchpatch {
    name = "openssh-gssapi.patch";
    url = "https://anonscm.debian.org/cgit/pkg-ssh/openssh.git/plain/debian"
        + "/patches/gssapi.patch?id=255b8554a50b5c75fca63f76b1ac837c0d4fb7aa";
    sha256 = "0yg9iq7vb2fkvy36ar0jxk29pkw0h3dhv5vn8qncc3pgwx3617n2";
  };

in
with stdenv.lib;
stdenv.mkDerivation rec {
  # Please ensure that openssh_with_kerberos still builds when
  # bumping the version here!
  name = "openssh-${version}";
  version = "7.4p1";

  src = fetchurl {
    url = "mirror://openbsd/OpenSSH/portable/${name}.tar.gz";
    sha256 = "1l8r3x4fr2kb6xm95s7kjdif1wp6f94d4kljh4qjj9109shw87qv";
  };

  prePatch = optionalString hpnSupport
    ''
      gunzip -c ${hpnSrc} | patch -p1
      export NIX_LDFLAGS="$NIX_LDFLAGS -lgcc_s"
    '';

  patches =
    [
      ./locale_archive.patch
      ./fix-host-key-algorithms-plus.patch

      # See discussion in https://github.com/NixOS/nixpkgs/pull/16966
      ./dont_create_privsep_path.patch
    ]
    ++ optional withGssapiPatches gssapiSrc;

  buildInputs = [ zlib openssl libedit pkgconfig pam ]
    ++ optional withKerberos [ kerberos ];

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
    ++ optional withKerberos "--with-kerberos5=${kerberos}"
    ++ optional stdenv.isDarwin "--disable-libutil"
    ++ optional (!linkOpenssl) "--without-openssl";

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
    homepage = "http://www.openssh.com/";
    description = "An implementation of the SSH protocol";
    license = stdenv.lib.licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ eelco aneeshusa ];
    broken = hpnSupport; # probably after 6.7 update
  };
}
