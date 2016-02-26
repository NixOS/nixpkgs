{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "paxctl-${version}";
  version = "0.9";

  src = fetchurl {
    url = "http://pax.grsecurity.net/${name}.tar.gz";
    sha256 = "0biw882fp1lmgs6kpxznp1v6758r7dg9x8iv5a06k0b82bcdsc53";
  };

  preBuild = ''
    sed "s|--owner 0 --group 0||g" -i Makefile
  '';

  makeFlags = [
    "DESTDIR=$(out)"
    "MANDIR=share/man/man1"
  ];

  # FIXME needs gcc 4.9 in bootstrap tools
  hardeningDisable = [ "stackprotector" ];

  setupHook = ./setup-hook.sh;

  meta = with stdenv.lib; {
    description = "A tool for controlling PaX flags on a per binary basis";
    homepage    = "https://pax.grsecurity.net";
    license     = licenses.gpl2;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
