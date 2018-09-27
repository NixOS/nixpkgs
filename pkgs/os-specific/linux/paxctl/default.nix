{ fetchurl, stdenv, elf-header }:

stdenv.mkDerivation rec {
  name = "paxctl-${version}";
  version = "0.9";

  src = fetchurl {
    url = "https://pax.grsecurity.net/${name}.tar.gz";
    sha256 = "0biw882fp1lmgs6kpxznp1v6758r7dg9x8iv5a06k0b82bcdsc53";
  };

  # TODO Always do first way next mass rebuild.
  buildInputs = stdenv.lib.optional
    (!stdenv.hostPlatform.isLinux || !stdenv.buildPlatform.isLinux)
    elf-header;

  # TODO Always do first way next mass rebuild.
  preBuild = if !stdenv.hostPlatform.isLinux || !stdenv.buildPlatform.isLinux then ''
    sed -i Makefile \
      -e 's|--owner 0 --group 0||g' \
      -e '/CC:=gcc/d'
  '' else ''
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
    platforms   = platforms.all;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
