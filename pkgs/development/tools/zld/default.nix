{ stdenv, lib, fetchzip }:

stdenv.mkDerivation rec {
  pname = "zld";
  version = "1.3.4";
  src = fetchzip {
    url = "https://github.com/michaeleisel/zld/releases/download/${version}/zld.zip";
    sha256 = "sha256-w1Pe96sdCbrfYdfBpD0BBXu7cFdW3cpo0PCn1+UyZI8=";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp zld $out/bin/
  '';

  meta = with lib; {
    description = "Faster version of Apple's linker";
    homepage = "https://github.com/michaeleisel/zld";
    license = licenses.mit;
    maintainers = [ maintainers.rgnns ];
    platforms = platforms.darwin;
    hydraPlatforms = [];
  };
}
