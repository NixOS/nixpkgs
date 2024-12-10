{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "funnelweb";
  version = "3.20";

  src = fetchurl {
    url = "http://www.ross.net/funnelweb/download/funnelweb_v320/funnelweb_v320_source.tar.gz";
    sha256 = "0zqhys0j9gabrd12mnk8ibblpc8dal4kbl8vnhxmdlplsdpwn4wg";
  };

  buildPhase = ''
    cd source
    ${stdenv.cc}/bin/cc -D__linux__ -o fw *.c
  '';

  installPhase = ''
    install -d $out/bin
    install fw $out/bin/fw
  '';

  meta = with lib; {
    version = "3.20";
    description = "A simple, reliable literate-programming macro preprocessor";
    mainProgram = "fw";
    homepage = "http://www.ross.net/funnelweb/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.AndersonTorres ];
  };
}
#TODO: implement it for other platforms
#TODO: Documentation files
