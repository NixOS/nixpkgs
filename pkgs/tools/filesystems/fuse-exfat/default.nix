{ stdenv, fetchurl, pkgconfig, fuse, scons }:

stdenv.mkDerivation rec {
  name = "fuse-exfat-1.1.0";

  src = fetchurl {
    sha256 = "0glmgwrf0nv09am54i6s35ksbvrywrwc51w6q32mv5by8475530r";
    url = "https://docs.google.com/uc?export=download&id=0B7CLI-REKbE3VTdaa0EzTkhYdU0";
    name = "${name}.tar.gz";
  };

  buildInputs = [ pkgconfig fuse scons ];

  buildPhase = ''
    export CCFLAGS="-O2 -Wall -std=c99 -I${fuse}/include"
    export LDFLAGS="-L${fuse}/lib"
    mkdir -pv $out/sbin
    scons DESTDIR=$out/sbin install
  '';

  installPhase = ":";

  meta = with stdenv.lib; {
    homepage = http://code.google.com/p/exfat/;
    description = "A FUSE-based filesystem that allows read and write access to exFAT devices";
    platforms = with platforms; linux;
    license = with licenses; gpl2Plus;
    maintainers = with maintainers; [ nckx ];
  };
}

