{ stdenv, fetchurl, zlib, openssl, perl, libedit, pkgconfig, pam
, etcDir ? null
, hpnSupport ? false
, withKerberos ? false
, kerberos
}:

assert withKerberos -> kerberos != null;

let

  hpnSrc = fetchurl {
    url = mirror://sourceforge/hpnssh/openssh-6.3p1-hpnssh14v2.diff.gz;
    sha256 = "1jldqjwry9qpxxzb3mikfmmmv90mfb7xkmcfdbvwqac6nl3r7bi3";
  };
  optionalString = stdenv.lib.optionalString;

in

stdenv.mkDerivation rec {
  name = "openssh-6.6p1";

  src = fetchurl {
    url = "ftp://ftp.nl.uu.net/pub/OpenBSD/OpenSSH/portable/${name}.tar.gz";
    sha256 = "1fq3w86q05y5nn6z878wm312k0svaprw8k007188fd259dkg1ha8";
  };

  prePatch = stdenv.lib.optionalString hpnSupport
    ''
      gunzip -c ${hpnSrc} | patch -p1
      export NIX_LDFLAGS="$NIX_LDFLAGS -lgcc_s"
    '';

  patches = [ ./locale_archive.patch ];

  buildInputs = [ zlib openssl libedit pkgconfig pam ]
    ++ stdenv.lib.optional withKerberos [ kerberos ];

  # I set --disable-strip because later we strip anyway. And it fails to strip
  # properly when cross building.
  configureFlags =
    ''
      --with-mantype=man
      --with-libedit=yes
      --disable-strip
      ${if pam != null then "--with-pam" else "--without-pam"}
      ${optionalString (etcDir != null) "--sysconfdir=${etcDir}"}
      ${optionalString withKerberos "--with-kerberos5=${kerberos}"}
    '';

  preConfigure =
    ''
      configureFlags="$configureFlags --with-privsep-path=$out/empty"
      mkdir -p $out/empty
    '';

  postInstall =
    ''
      # Install ssh-copy-id, it's very useful.
      cp contrib/ssh-copy-id $out/bin/
      chmod +x $out/bin/ssh-copy-id
      cp contrib/ssh-copy-id.1 $out/share/man/man1/

      mkdir -p $out/etc/ssh
      cp moduli $out/etc/ssh/
    '';

  installTargets = "install-nosysconf";

  meta = with stdenv.lib; {
    homepage = "http://www.openssh.org/";
    description = "An implementation of the SSH protocol";
    license = "bsd";
    platforms = platforms.unix;
    maintainers = with maintainers; [ eelco ];
    broken = hpnSupport; # cf. https://github.com/NixOS/nixpkgs/pull/1640
  };
}
