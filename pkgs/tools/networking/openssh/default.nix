{ stdenv, fetchurl, zlib, openssl, perl, libedit, pkgconfig, pam
, etcDir ? null
, hpnSupport ? false
}:

let

  hpnSrc = fetchurl {
    url = http://www.psc.edu/networking/projects/hpn-ssh/openssh-5.9p1-hpn13v12.diff.gz;
    sha256 = "0h1h45vic4zks5bc5mvkc50rlgy2c219vn3rmpmalgm5hws9qjbl";
  };

in

stdenv.mkDerivation rec {
  name = "openssh-6.1p1";

  src = fetchurl {
    url = "ftp://ftp.nl.uu.net/pub/OpenBSD/OpenSSH/portable/${name}.tar.gz";
    sha1 = "751c92c912310c3aa9cadc113e14458f843fc7b3";
  };

  prePatch = stdenv.lib.optionalString hpnSupport
    ''
      gunzip -c ${hpnSrc} | patch -p1
      export NIX_LDFLAGS="$NIX_LDFLAGS -lgcc_s"
    '';
    
  patches = [ ./locale_archive.patch ];

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
  };
}
