{ stdenv, lib, fetchzip }:

stdenv.mkDerivation rec {
  pname = "zld";
  version = "1.3.3";
  src = fetchzip {
    url = "https://github.com/michaeleisel/zld/releases/download/${version}/zld.zip";
    sha256 = "0qb4l7a4vhpnzkgzhw0jivz40jr5gdhqfyynhbkhn7ryh5s52d1p";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp zld $out/bin/
  '';

  meta = with lib; {
    description = "A faster version of Apple's linker";
    homepage = "https://github.com/michaeleisel/zld";
    license = licenses.mit;
    maintainers = [ maintainers.rgnns ];
    platforms = platforms.darwin;
    hydraPlatforms = [];
  };
}
