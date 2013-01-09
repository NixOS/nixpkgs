{stdenv, fetchurl, pciutils, python}:

stdenv.mkDerivation rec {
  version = "1.30";
  name = "x86info-${version}";

  src = fetchurl {
    url = "http://codemonkey.org.uk/projects/x86info/${name}.tgz";
    sha256 = "0a4lzka46nabpsrg3n7akwr46q38f96zfszd73xcback1s2hjc7y";
  };

  buildInputs = [ pciutils python ];

  installPhase = ''
    ensureDir $out/bin
    cp x86info lsmsr $out/bin
  '';

  meta = {
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [jcumming];
    description = "x86info, a CPU identification utility.";
  };
}
