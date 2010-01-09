{stdenv, fetchurl, libmusclecard, pkgconfig, pcsclite}:
stdenv.mkDerivation {
  name = "muscleframework-mcardplugin-1.1.7";

  src = fetchurl {
    url = https://alioth.debian.org/frs/download.php/3056/muscleframework-1.1.7.tar.gz;
    sha256 = "081sq25fa3k1gz0asq2995krx7pzxbfq5vx1ahsd5sbmwnplv94v";
  };

  preConfigure = ''
    cd MCardPlugin
    configureFlags="$configureFlags --enable-muscledropdir=$out/pcsc/services"
  '';

  buildInputs = [ libmusclecard pkgconfig pcsclite];

  meta = {
    description = "Smart card framework";
    homepage = http://muscleplugins.alioth.debian.org/;
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
