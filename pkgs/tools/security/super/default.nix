{ stdenv, fetchurl, fetchpatch }:

stdenv.mkDerivation rec {
  name = "super-3.30.0";

  src = fetchurl {
    name = "${name}.tar.gz";
    url = "https://www.ucolick.org/~will/RUE/super/${name}-tar.gz";
    sha256 = "0k476f83w7f45y9jpyxwr00ikv1vhjiq0c26fgjch9hnv18icvwy";
  };

  prePatch = ''
    # do not set sticky bit in nix store
    substituteInPlace Makefile.in \
      --replace "-o root" "" \
      --replace 04755 755
  '';

  patches = [
   (fetchpatch { url = https://salsa.debian.org/debian/super/raw/debian/3.30.0-7/debian/patches/14-Fix-unchecked-setuid-call.patch;
                 sha256 = "08m9hw4kyfjv0kqns1cqha4v5hkgp4s4z0q1rgif1fnk14xh7wqh";
               })
  ];

  NIX_CFLAGS_COMPILE = "-D_GNU_SOURCE";

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ];

  installFlags = [ "sysconfdir=$(out)/etc" "localstatedir=$(TMPDIR)" ];

  meta = {
    homepage = "https://www.ucolick.org/~will/#super";
    description = "Allows users to execute scripts as if they were root";
    longDescription =
      ''
        This package provides two commands: 1) “super”, which allows
        users to execute commands under a different uid/gid (specified
        in /etc/super.tab); and 2) “setuid”, which allows root to
        execute a command under a different uid.
      '';
    platforms = stdenv.lib.platforms.linux;
  };
}
