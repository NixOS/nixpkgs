{ stdenv, fetchurl, fetchpatch, zlib, openssl, perl, libedit, pkgconfig, pam
, etcDir ? null
, hpnSupport ? false
, withKerberos ? false
, withGssapiPatches ? withKerberos
, kerberos
}:

assert withKerberos -> kerberos != null;

let

  hpnSrc = fetchurl {
    url = mirror://sourceforge/hpnssh/openssh-6.6p1-hpnssh14v5.diff.gz;
    sha256 = "682b4a6880d224ee0b7447241b684330b731018585f1ba519f46660c10d63950";
  };

  gssapiSrc = fetchpatch {
    url = "http://anonscm.debian.org/cgit/pkg-ssh/openssh.git/plain/debian/patches/gssapi.patch?h=debian/6.9p1-3";
    sha256 = "03zlgkb3a1igj20kn8cz55ggaxg65h6f0kg20m39m0wsb94qjdb1";
  };

in
with stdenv.lib;
stdenv.mkDerivation rec {
  name = "openssh-6.9p1";

  src = fetchurl {
    url = "mirror://openbsd/OpenSSH/portable/${name}.tar.gz";
    sha256 = "1zkci5nbpb4frmzj2vr3kv9j47x2h72kvybcpr0d8mzk73sls1vf";
  };

  prePatch = optionalString hpnSupport
    ''
      gunzip -c ${hpnSrc} | patch -p1
      export NIX_LDFLAGS="$NIX_LDFLAGS -lgcc_s"
    '';

  patches = [ ./locale_archive.patch ./openssh-6.9p1-security-7.0.patch ./disable-roaming.patch ]
    ++ optional withGssapiPatches gssapiSrc;

  buildInputs = [ zlib openssl libedit pkgconfig pam ]
    ++ optional withKerberos [ kerberos ];

  # I set --disable-strip because later we strip anyway. And it fails to strip
  # properly when cross building.
  configureFlags = [
    "--localstatedir=/var"
    "--with-pid-dir=/run"
    "--with-mantype=man"
    "--with-libedit=yes"
    "--disable-strip"
    (if pam != null then "--with-pam" else "--without-pam")
  ] ++ optional (etcDir != null) "--sysconfdir=${etcDir}"
    ++ optional withKerberos "--with-kerberos5=${kerberos}"
    ++ optional stdenv.isDarwin "--disable-libutil";

  preConfigure = ''
    configureFlagsArray+=("--with-privsep-path=$out/empty")
    mkdir -p $out/empty
  '';

  enableParallelBuilding = true;

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
    homepage = "http://www.openssh.org/";
    description = "An implementation of the SSH protocol";
    license = stdenv.lib.licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ eelco ];
    broken = hpnSupport; # probably after 6.7 update
  };
}
