{lib, stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "sysklogd";
  version = "1.5.1";

  src = fetchurl {
    url = "http://www.infodrom.org/projects/sysklogd/download/sysklogd-${version}.tar.gz";
    sha256 = "00f2wy6f0qng7qzga4iicyzl9j8b7mp6mrpfky5jxj93ms2w2rji";
  };

  patches = [ ./systemd.patch ./union-wait.patch ./fix-includes-for-musl.patch ];

  env.NIX_CFLAGS_COMPILE = "-DSYSV";

  installFlags = [ "BINDIR=$(out)/sbin" "MANDIR=$(out)/share/man" "INSTALL=install" ];

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  postPatch = ''
    # Disable stripping during installation, stripping will be done anyway.
    # Fixes cross-compilation.
    substituteInPlace Makefile \
      --replace "-m 500 -s" "-m 500"
  '';

  preConfigure =
    ''
      sed -e 's@-o \''${MAN_USER} -g \''${MAN_GROUP} -m \''${MAN_PERMS} @@' -i Makefile
    '';

  preInstall = "mkdir -p $out/share/man/man5/ $out/share/man/man8/ $out/sbin";

  meta = with lib; {
    description = "System logging daemon";
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
