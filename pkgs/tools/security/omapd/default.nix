{ stdenv, fetchurl, cmake, qt4, gdb, zlib }:
stdenv.mkDerivation rec {

  name = "omapd-${version}";
  version = "0.9.2";

  src = fetchurl {
    url = "http://omapd.googlecode.com/files/${name}.tgz";
    sha256 = "0d7lgv957jhbsav60j50jhdy3rpcqgql74qsniwnnpm3yqj9p0xc";
  };

  patches = [ ./zlib.patch ];

  buildInputs = [ cmake qt4 zlib gdb ];

  phases = [ "unpackPhase" "patchPhase" "buildPhase" "installPhase" ];

  buildPhase = ''
    (cd plugins/RAMHashTables; qmake; make)
    qmake
    make
    '';

  installPhase = ''
    mkdir -p $out $out/bin $out/etc $out/usr/lib/omapd/plugins
    cp omapd $out/bin/.
    cp omapd.conf $out/etc/.
    cp plugins/libRAMHashTables.so $out/usr/lib/omapd/plugins/.
    ln -s $out/usr/lib/omapd/plugins $out/bin/plugins
    '';

  meta = with stdenv.lib; {
    homepage = http://code.google.com/p/omapd;
    description = "IF-MAP Server that implements the IF-MAP v1.1 and v2.0 specifications published by the Trusted Computing Group (TCG)";
    license = licenses.gpl3;
    maintainers = [ maintainers.tstrobel ];
    platforms = platforms.linux;
  };
}
