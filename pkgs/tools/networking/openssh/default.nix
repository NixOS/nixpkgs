{ stdenv, fetchurl, fetchpatch, zlib, openssl, libedit, pkgconfig, pam, autoreconfHook
, etcDir ? null
, hpnSupport ? false
, withKerberos ? true
, withGssapiPatches ? false
, kerberos
, libfido2
, withFIDO ? stdenv.hostPlatform.isUnix
, linkOpenssl? true
}:

let

  # **please** update this patch when you update to a new openssh release.
  gssapiPatch = fetchpatch {
    name = "openssh-gssapi.patch";
    url = "https://salsa.debian.org/ssh-team/openssh/raw/debian/1%258.2p1-1/debian/patches/gssapi.patch";
    sha256 = "081gryqkfr5zr4f5m4v0piq1sxz06sb38z5lqxccgpivql7pa8d8";
  };

in
with stdenv.lib;
stdenv.mkDerivation rec {
  pname = "openssh";
  version = if hpnSupport then "7.8p1" else "8.2p1";

  src = if hpnSupport then
      fetchurl {
        url = "https://github.com/rapier1/openssh-portable/archive/hpn-KitchenSink-7_8_P1.tar.gz";
        sha256 = "05q5hxx7fzcgd8a5i0zk4fwvmnz4xqk04j489irnwm7cka7xdqxw";
      }
    else
      fetchurl {
        url = "mirror://openbsd/OpenSSH/portable/${pname}-${version}.tar.gz";
        sha256 = "0wg6ckzvvklbzznijxkk28fb8dnwyjd0w30ra0afwv6gwr8m34j3";
      };

  patches =
    [
      ./locale_archive.patch

      # See discussion in https://github.com/NixOS/nixpkgs/pull/16966
      ./dont_create_privsep_path.patch

      ./ssh-keysign.patch
    ] ++ optional hpnSupport
      # CVE-2018-20685, can probably be dropped with next version bump
      # See https://sintonen.fi/advisories/scp-client-multiple-vulnerabilities.txt
      # for details
      (fetchpatch {
        name = "CVE-2018-20685.patch";
        url = https://github.com/openssh/openssh-portable/commit/6010c0303a422a9c5fa8860c061bf7105eb7f8b2.patch;
        sha256 = "0q27i9ymr97yb628y44qi4m11hk5qikb1ji1vhvax8hp18lwskds";
      })
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
    homepage = http://www.openssh.com/;
    description = "An implementation of the SSH protocol";
    license = stdenv.lib.licenses.bsd2;
    platforms = platforms.unix ++ platforms.windows;
    maintainers = with maintainers; [ eelco aneeshusa ];
    broken = hpnSupport;
  };
}
