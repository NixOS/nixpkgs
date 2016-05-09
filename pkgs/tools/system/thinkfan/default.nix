{ stdenv, fetchurl, cmake }:

stdenv.mkDerivation rec {
  name = "thinkfan-${version}";
  version = "0.9.3";

  src = fetchurl {
    url = "mirror://sourceforge/thinkfan/thinkfan-${version}.tar.gz";
    sha256 = "0nz4c48f0i0dljpk5y33c188dnnwg8gz82s4grfl8l64jr4n675n";
  };

  nativeBuildInputs = [ cmake ];

  installPhase = ''
    install -Dm755 {.,$out/bin}/thinkfan

    cd "$NIX_BUILD_TOP"; cd "$sourceRoot" # attempt to be a bit robust
    install -Dm644 {.,$out/share/doc/thinkfan}/README
    cp -R examples $out/share/doc/thinkfan
    install -Dm644 {src,$out/share/man/man1}/thinkfan.1
  '';

  meta = {
    license = stdenv.lib.licenses.gpl3;
    homepage = http://thinkfan.sourceforge.net/;
    maintainers = with stdenv.lib.maintainers; [ iElectric nckx ];
    platforms = stdenv.lib.platforms.linux;
  };
}
