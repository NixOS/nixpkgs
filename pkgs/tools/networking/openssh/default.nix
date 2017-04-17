{ stdenv, fetchurl, fetchpatch, zlib, openssl, perl, libedit, pkgconfig, pam, autoreconfHook
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
  version = "7.5p1";

  src = if hpnSupport then
      fetchurl {
        url = "https://github.com/rapier1/openssh-portable/archive/hpn-7_4_P1.tar.gz";
        sha256 = "1ppz5fm3ddpbz4k81wpdzwqj6wbx58wwdm6wz41vnr7vhar7wk83";
      }
    else
      fetchurl {
        url = "mirror://openbsd/OpenSSH/portable/${name}.tar.gz";
        sha256 = "1w7rb5gbrikxdkp8w7zxnci4549gk4bw1lml01s59w5rzb2y6ilq";
      };

  patches =
    [
      ./locale_archive.patch

      # See discussion in https://github.com/NixOS/nixpkgs/pull/16966
      ./dont_create_privsep_path.patch
    ]
    ++ optional withGssapiPatches gssapiSrc;

  buildInputs = [ zlib openssl libedit pkgconfig pam ]
    ++ optional withKerberos kerberos
    ++ optional hpnSupport autoreconfHook;

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
  };
}
