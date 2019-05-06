{ stdenv, glibc, garden_src }:

stdenv.mkDerivation {
  name = "init";
  version = "0.0.1";
  src = garden_src;

  buildInputs = [ glibc.static ];

  postUnpack = ''
    export sourceRoot=$sourceRoot/src/code.cloudfoundry.org/guardian/cmd/init
  '';

  buildPhase = ''
    gcc -static -o init *.c
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv init $out/bin/
  '';

  meta = {
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [ edude03 dxf ];
  };

}
