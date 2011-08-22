{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "super-3.30.0";

  src = fetchurl {
    name = "${name}.tar.gz";
    url = "http://ftp.ucolick.org/pub/users/will/${name}-tar.gz";
    sha256 = "1sxgixx1yg7h8g9799v79rk15gb39gn7p7fx032c078wxx38qwq4";
  };

  NIX_CFLAGS_COMPILE = "-D_GNU_SOURCE";

  configureFlags = "--sysconfdir=/etc --localstatedir=/var";

  installFlags = "sysconfdir=$(out)/etc localstatedir=$(TMPDIR)";

  meta = {
    homepage = http://ftp.ucolick.org/pub/users/will/;
    description = "Allows users to execute scripts as if they were root";
    longDescription =
      ''
        This package provides two commands: 1) “super”, which allows
        users to execute commands under a different uid/gid (specified
        in /etc/super.tab); and 2) “setuid”, which allows root to
        execute a command under a different uid.
      '';
  };  
}
