{lib, stdenv, fetchurl, pciutils, python2}:

stdenv.mkDerivation rec {
  version = "1.30";
  pname = "x86info";

  src = fetchurl {
    url = "http://codemonkey.org.uk/projects/x86info/${pname}-${version}.tgz";
    sha256 = "0a4lzka46nabpsrg3n7akwr46q38f96zfszd73xcback1s2hjc7y";
  };

  preConfigure = ''
    patchShebangs .

    # ignore warnings
    sed -i 's/-Werror -Wall//' Makefile
  '';

  buildInputs = [ pciutils python2 ];

  installPhase = ''
    mkdir -p $out/bin
    cp x86info lsmsr $out/bin
  '';

  meta = {
    description = "Identification utility for the x86 series of processors";
    longDescription =
    ''
      x86info will identify all Intel/AMD/Centaur/Cyrix/VIA CPUs. It leverages
      the cpuid kernel module where possible.  it supports parsing model specific
      registers (MSRs) via the msr kernel module.  it will approximate processor
      frequency, and identify the cache sizes and layout.
    '';
    platforms = [ "i686-linux" "x86_64-linux" ];
    license = lib.licenses.gpl2;
    homepage = "http://codemonkey.org.uk/projects/x86info/";
    maintainers = with lib.maintainers; [jcumming];
  };
}
