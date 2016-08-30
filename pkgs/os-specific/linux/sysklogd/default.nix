{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "sysklogd-1.5.1";

  src = fetchurl {
    url = http://www.infodrom.org/projects/sysklogd/download/sysklogd-1.5.1.tar.gz;
    sha256 = "00f2wy6f0qng7qzga4iicyzl9j8b7mp6mrpfky5jxj93ms2w2rji";
  };

  patches = [ ./systemd.patch ./union-wait.patch ];

  NIX_CFLAGS_COMPILE = "-DSYSV";

  installFlags = "BINDIR=$(out)/sbin MANDIR=$(out)/share/man INSTALL=install";

  preConfigure =
    ''
      sed -e 's@-o \''${MAN_USER} -g \''${MAN_GROUP} -m \''${MAN_PERMS} @@' -i Makefile
    '';

  preInstall = "mkdir -p $out/share/man/man5/ $out/share/man/man8/ $out/sbin";

  meta = {
    description = "A system logging daemon";
    platforms = stdenv.lib.platforms.linux;
  };
}
