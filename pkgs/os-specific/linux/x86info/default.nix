{stdenv, fetchurl, pciutils, python}:

stdenv.mkDerivation rec {
  version = "1.30";
  name = "x86info-${version}";

  src = fetchurl {
    url = "http://codemonkey.org.uk/projects/x86info/${name}.tgz";
    sha256 = "0a4lzka46nabpsrg3n7akwr46q38f96zfszd73xcback1s2hjc7y";
  };

  preConfigure = "patchShebangs .";

  buildInputs = [ pciutils python ];

  installPhase = ''
    ensureDir $out/bin
    cp x86info lsmsr $out/bin
  '';

  meta = {
    description = "An identification utility for the x86 series of processors.";
    longDescription =
    ''
      x86info will identify all Intel/AMD/Centaur/Cyrix/VIA CPUs. It leverages
      the cpuid kernel module where possible.  it supports parsing model specific
      registers (MSRs) via the msr kernel module.  it will approximate processor
      frequency, and identify the cache sizes and layout. 
    '';
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2;
    homepage = http://codemonkey.org.uk/projects/x86info/;
    maintainers = with stdenv.lib.maintainers; [jcumming];
  };
}
