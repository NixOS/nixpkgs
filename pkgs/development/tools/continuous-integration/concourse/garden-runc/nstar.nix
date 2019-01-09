{
  garden_src,
  glibc,
  stdenv,
}:

stdenv.mkDerivation {
  name = "nstar";
  version = "0.0.1";
  src = garden_src;

  buildInputs = [ glibc.static ];

  postUnpack = ''
    export sourceRoot=$sourceRoot/src/code.cloudfoundry.org/guardian/rundmc/nstar
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv nstar "$out/bin"
  '';

  meta = {
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [ edude03 dxf ];
  };

}
