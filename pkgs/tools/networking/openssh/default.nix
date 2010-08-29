{ stdenv, fetchurl, zlib, openssl, perl, libedit, pkgconfig, pam
, etcDir ? null
, hpnSupport ? false
}:

let

  hpnSrc = fetchurl {
    url = http://www.psc.edu/networking/projects/hpn-ssh/openssh-5.3p1-hpn13v7.diff.gz;
    sha256 = "1kqir6v14z77l0wn9j4jzdqsip5s1ky34w749psvbshbp9dzizn8";
  };

in

stdenv.mkDerivation rec {
  name = "openssh-5.6p1";

  src = fetchurl {
    url = "ftp://ftp.nl.uu.net/pub/OpenBSD/OpenSSH/portable/${name}.tar.gz";
    sha256 = "0avc7jgp8i2jlp7b8q8g4nyil56v5fp09c1v54dc4ql15cxzb2jk";
  };

  prePatch = stdenv.lib.optionalString hpnSupport
    ''
      gunzip -c ${hpnSrc} | patch -p1
    '';
    
  patches = [ ./locale_archive.patch ];

  buildInputs = [ zlib openssl perl libedit pkgconfig pam ];

  configureFlags =
    ''
      --with-mantype=man
      --with-libedit=yes
      ${if pam != null then "--with-pam" else "--without-pam"}
      ${if etcDir != null then "--sysconfdir=${etcDir}" else ""}
    '';

  preConfigure =
    ''
      configureFlags="$configureFlags --with-privsep-path=$out/empty"
      ensureDir $out/empty
    '';

  postInstall =
    ''
      # Install ssh-copy-id, it's very useful.
      cp contrib/ssh-copy-id $out/bin/
      chmod +x $out/bin/ssh-copy-id
      cp contrib/ssh-copy-id.1 $out/share/man/man1/

      ensureDir $out/etc/ssh
      cp moduli $out/etc/ssh/
    '';

  installTargets = "install-nosysconf";

  meta = {
    homepage = http://www.openssh.org/;
    description = "An implementation of the SSH protocol";
    license = "bsd";
  };
}
