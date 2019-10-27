{ stdenv, fetchurl, groff }:

stdenv.mkDerivation rec {
  pname = "setserial";
  version = "2.17";

  src = fetchurl {
    url = "mirror://sourceforge/setserial/${pname}-${version}.tar.gz";
    sha256 = "0jkrnn3i8gbsl48k3civjmvxyv9rbm1qjha2cf2macdc439qfi3y";
  };

  buildInputs = [ groff ];

  installFlags = ''DESTDIR=$(out)'';

  postConfigure = ''
    sed -e s@/usr/man/@/share/man/@ -i Makefile
  '';

  preInstall = ''mkdir -p "$out/bin" "$out/share/man/man8"'';

  meta = {
    description = "Serial port configuration utility";
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2;
  };
}
