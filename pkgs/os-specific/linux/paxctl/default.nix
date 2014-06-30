{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "paxctl-${version}";
  version = "0.8";

  src = fetchurl {
    url = "http://pax.grsecurity.net/${name}.tar.gz";
    sha256 = "107gmriq5icsk9yni5q949rnjapjkcs0823pw6zra6h1xml2f0mm";
  };

  preBuild = ''
    sed "s|--owner 0 --group 0||g" -i Makefile
  '';

  makeFlags = [
    "DESTDIR=$(out)"
    "MANDIR=share/man/man1"
  ];

  setupHook = ./setup-hook.sh;

  meta = with stdenv.lib; {
    description = "A tool for controlling PaX flags on a per binary basis";
    homepage    = "https://pax.grsecurity.net";
    license     = licenses.gpl2;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice wizeman ];
  };
}
