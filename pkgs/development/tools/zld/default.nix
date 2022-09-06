{ stdenv, lib, fetchzip }:

stdenv.mkDerivation rec {
  pname = "zld";
  version = "1.3.4";
  src = fetchzip {
    url = "https://github.com/michaeleisel/zld/releases/download/${version}/zld.zip";
    sha256 = "1rzdcrky0dl9n7niv39a5gc7q7rwl8jv6h77nvm6gwdymkjf2973";
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
