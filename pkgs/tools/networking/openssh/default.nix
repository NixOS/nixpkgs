{ stdenv, fetchurl, zlib, openssl, perl, libedit, pkgconfig, pam
, etcDir ? null
, hpnSupport ? false
}:

let

  hpnSrc = fetchurl {
    url = http://nixos.org/tarballs/openssh-6.1p1-hpn13v14.diff.gz;
    sha256 = "14das6lim6fxxnx887ssw76ywsbvx3s4q3n43afgh5rgvs4xmnnq";
  };

in

stdenv.mkDerivation rec {
  name = "openssh-6.2p1";

  src = fetchurl {
    url = "ftp://ftp.nl.uu.net/pub/OpenBSD/OpenSSH/portable/${name}.tar.gz";
    sha1 = "8824708c617cc781b2bb29fa20bd905fd3d2a43d";
  };

  prePatch = stdenv.lib.optionalString hpnSupport
    ''
      gunzip -c ${hpnSrc} | patch -p1
      export NIX_LDFLAGS="$NIX_LDFLAGS -lgcc_s"
    '';

  patches =
    [ ./locale_archive.patch
      # Upstream fix for gratuitous "no such identity" warnings.
      ./fix-identity-warnings.patch
    ];

  buildInputs = [ zlib openssl libedit pkgconfig pam ];

  # I set --disable-strip because later we strip anyway. And it fails to strip
  # properly when cross building.
  configureFlags =
    ''
      --with-mantype=man
      --with-libedit=yes
      --disable-strip
      ${if pam != null then "--with-pam" else "--without-pam"}
      ${if etcDir != null then "--sysconfdir=${etcDir}" else ""}
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

  meta = {
    homepage = http://www.openssh.org/;
    description = "An implementation of the SSH protocol";
    license = "bsd";
    platforms = stdenv.lib.platforms.linux;
    maintainers = stdenv.lib.maintainers.eelco;
  };
}
