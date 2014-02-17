{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "paxctl-${version}";
  version = "0.7";

  src = fetchurl {
    url = "https://pax.grsecurity.net/${name}-${version}.tar.bz2";
    sha256 = "1j6dg6wd1v7na5i4xj8zmbff0mdqdnw6cvqy0rsbz5anra27f1zp";
  };

  preBuild = ''
    sed "s|--owner 0 --group 0||g" -i Makefile
  '';

  makeFlags = [
    "DESTDIR=$(out)"
    "MANDIR=share/man/man1"
  ];

  meta = {
    description = "A tool for controlling PaX flags on a per binary basis";
    homepage    = "https://pax.grsecurity.net";
    license     = stdenv.lib.licenses.gpl2;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
