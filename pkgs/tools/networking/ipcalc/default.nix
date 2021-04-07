{lib, stdenv, fetchurl, perl}:
stdenv.mkDerivation rec {
  pname = "ipcalc";
  version = "0.41";
  src = fetchurl {
    url = "http://jodies.de/ipcalc-archive/${pname}-${version}.tar.gz";
    sha256 = "dda9c571ce3369e5b6b06e92790434b54bec1f2b03f1c9df054c0988aa4e2e8a";
  };
  buildInputs = [perl];
  installPhase = ''
    mkdir -p $out/bin
    cp ipcalc $out/bin
  '';
  meta = {
    description = "Simple IP network calculator";
    homepage = "http://jodies.de/ipcalc";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
  };
}
