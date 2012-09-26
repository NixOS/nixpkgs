{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "sysklogd-1.5";

  src = fetchurl {
    url = http://www.infodrom.org/projects/sysklogd/download/sysklogd-1.5.tar.gz;
    sha256 = "0wxpkrznqwz4dy11k90s2sqszwp7d4mlc0ag8288wa193plvhsb1";
  };

  patches = [ ./systemd.patch ];

  installFlags = "BINDIR=$(out)/sbin MANDIR=$(out)/share/man INSTALL=install";

  preConfigure =
    ''
      sed -e 's@-o \''${MAN_USER} -g \''${MAN_GROUP} -m \''${MAN_PERMS} @@' -i Makefile
    '';

  preInstall = "mkdir -p $out/share/man/man5/ $out/share/man/man8/ $out/sbin";

  meta = {
    description = "A system logging daemon";
  };
}
