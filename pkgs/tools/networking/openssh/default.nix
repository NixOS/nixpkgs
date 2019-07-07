{ stdenv, fetchurl, fetchpatch, zlib, openssl, libedit, pkgconfig, pam, autoreconfHook
, etcDir ? null
, hpnSupport ? false
, withKerberos ? true
, withGssapiPatches ? false
, kerberos
, linkOpenssl? true
}:

let

  # **please** update this patch when you update to a new openssh release.
  gssapiPatch = fetchpatch {
    name = "openssh-gssapi.patch";
    url = "https://salsa.debian.org/ssh-team/openssh/raw/"
      + "d80ebbf028196b2478beebf5a290b97f35e1eed9"
      + "/debian/patches/gssapi.patch";
    sha256 = "14j9cabb3gkhkjc641zbiv29mbvsmgsvis3fbj8ywsd21zc7m2wv";
  };

in
with stdenv.lib;
stdenv.mkDerivation rec {
  name = "openssh-${version}";
  version = if hpnSupport then "7.8p1" else "7.9p1";

  src = if hpnSupport then
      fetchurl {
        url = "https://github.com/rapier1/openssh-portable/archive/hpn-KitchenSink-7_8_P1.tar.gz";
        sha256 = "05q5hxx7fzcgd8a5i0zk4fwvmnz4xqk04j489irnwm7cka7xdqxw";
      }
    else
      fetchurl {
        url = "mirror://openbsd/OpenSSH/portable/${name}.tar.gz";
        sha256 = "1b8sy6v0b8v4ggmknwcqx3y1rjcpsll0f1f8f4vyv11x4ni3njvb";
      };

  patches =
    [
      ./locale_archive.patch

      # See discussion in https://github.com/NixOS/nixpkgs/pull/16966
      ./dont_create_privsep_path.patch

      # CVE-2018-20685, can probably be dropped with next version bump
      # See https://sintonen.fi/advisories/scp-client-multiple-vulnerabilities.txt
      # for details
      (fetchpatch {
        name = "CVE-2018-20685.patch";
        url = https://github.com/openssh/openssh-portable/commit/6010c0303a422a9c5fa8860c061bf7105eb7f8b2.patch;
        sha256 = "0q27i9ymr97yb628y44qi4m11hk5qikb1ji1vhvax8hp18lwskds";
      })
    ]
    ++ optional withGssapiPatches (assert withKerberos; gssapiPatch);

  postPatch =
    # On Hydra this makes installation fail (sometimes?),
    # and nix store doesn't allow such fancy permission bits anyway.
    ''
      substituteInPlace Makefile.in --replace '$(INSTALL) -m 4711' '$(INSTALL) -m 0711'
    '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ zlib openssl libedit pam ]
    ++ optional withKerberos kerberos
    ++ optional hpnSupport autoreconfHook
    ;

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
    ++ optional withKerberos (assert kerberos != null; "--with-kerberos5=${kerberos}")
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
    homepage = http://www.openssh.com/;
    description = "An implementation of the SSH protocol";
    license = stdenv.lib.licenses.bsd2;
    platforms = platforms.unix ++ platforms.windows;
    maintainers = with maintainers; [ eelco aneeshusa ];
  };
}
