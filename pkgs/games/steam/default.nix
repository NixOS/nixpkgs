{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "${program}-${version}";
  program = "steam";
  version = "1.0.0.49";

  src = fetchurl {
    url = "http://repo.steampowered.com/steam/pool/steam/s/steam/${program}_${version}.tar.gz";
    sha256 = "1c1gl5pwvb5gnnnqf5d9hpcjnfjjgmn4lgx8v0fbx1am5xf3p2gx";
  };

  installPhase = ''
    make DESTDIR=$out install
    mv $out/usr/* $out #*/
    rmdir $out/usr
  '';

  meta = {
    description = "A digital distribution platform";
    homepage = http://store.steampowered.com/;
    license = stdenv.lib.licenses.unfree;
    maintainers = [ stdenv.lib.maintainers.jagajaga ];
  };
}
