# The tarball has different plugins in it, and as I don't need all of them,
# I only build one of those in this derivation
# This is an arbitrary decision, and this simplicity fit my needs.
# Anyone can extend the extension to build all the plugins, or to make
# different derivations for each plugin.

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
    description = "MUSCLE smart card framework - mcard plugin";
    homepage = http://muscleplugins.alioth.debian.org/;
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
