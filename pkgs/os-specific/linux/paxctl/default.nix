{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "paxctl-${version}";
  version = "0.7";

  src = fetchurl {
    url = "http://pax.grsecurity.net/${name}.tar.bz2";
    sha256 = "1j6dg6wd1v7na5i4xj8zmbff0mdqdnw6cvqy0rsbz5anra27f1zp";
  };

  preBuild = ''
    sed "s|--owner 0 --group 0||g" -i Makefile
  '';

  makeFlags = [
    "DESTDIR=$(out)"
    "MANDIR=share/man/man1"
  ];

  meta = with stdenv.lib; {
    description = "A tool for controlling PaX flags on a per binary basis";
    homepage    = "https://pax.grsecurity.net";
    license     = licenses.gpl2;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice wizeman ];
  };
}
