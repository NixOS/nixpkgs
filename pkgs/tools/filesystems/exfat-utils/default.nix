{ stdenv, fetchurl, scons }:

let version = "1.1.1"; in
stdenv.mkDerivation rec {
  name = "exfat-utils-${version}";

  src = fetchurl {
    sha256 = "0ck2snhlhp965bb9a4y1g2lpl979sw1yznm79wbavyv174458i66";
    url = "https://docs.google.com/uc?export=download&id=0B7CLI-REKbE3UzNtSkRvdHBpdjQ";
    name = "${name}.tar.gz";
  };

  meta = with stdenv.lib; {
    description = "Free exFAT file system utilities";
    longDescription = ''
      Full-featured exFAT file system implementation for GNU/Linux and other
      Unix-like systems.
    '';
    homepage = https://code.google.com/p/exfat;
    license = with licenses; gpl2Plus;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ nckx ];
  };

  buildInputs = [ scons ];

  buildPhase = ''
    export CCFLAGS="-std=c99"
    mkdir -pv $out/sbin
    scons DESTDIR=$out/sbin install
  '';

  installPhase = ":";
}
