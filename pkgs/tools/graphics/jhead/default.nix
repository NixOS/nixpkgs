{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "jhead-2.87";

  src = fetchurl {
    url = http://www.sentex.net/~mwandel/jhead/jhead-2.87.tar.gz;
    sha256 = "0vpp5jz49w5qzjzq3vllrbff7fr906jy8a8sq12yq8kw6qwbjjsl";
  };

  patchPhase = ''
    sed -i s@/usr/bin@$out/bin@ makefile
  '';

  preInstall = ''
    mkdir -p $out/bin
  '';

  meta = {
    homepage = http://www.sentex.net/~mwandel/jhead/;
    description = "Exif Jpeg header manipulation tool";
    license = "free";
    maintainers = with stdenv.lib.maintainers; [viric];
  };
}
