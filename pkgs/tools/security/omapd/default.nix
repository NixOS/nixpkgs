{ lib, stdenv, fetchurl, qt4, gdb, zlib }:

stdenv.mkDerivation rec {
  pname = "omapd";
  version = "0.9.2";

  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/omapd/${pname}-${version}.tgz";
    sha256 = "0d7lgv957jhbsav60j50jhdy3rpcqgql74qsniwnnpm3yqj9p0xc";
  };

  patches = [ ./zlib.patch ];

  buildInputs = [ qt4 zlib gdb ];

  buildPhase = ''
    (cd plugins/RAMHashTables; qmake; make)
    qmake
    make
  '';

  installPhase = ''
    install -vD omapd $out/bin/omapd
    install -vD omapd.conf $out/etc/omapd.conf
    install -vD plugins/libRAMHashTables.so $out/usr/lib/omapd/plugins/libRAMHashTables.so
    ln -s $out/usr/lib/omapd/plugins $out/bin/plugins
  '';

  meta = with lib; {
    homepage = "https://code.google.com/archive/p/omapd/";
    description = "IF-MAP Server that implements the IF-MAP v1.1 and v2.0 specifications published by the Trusted Computing Group (TCG)";
    license = licenses.gpl3;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
